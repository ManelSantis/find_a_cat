import 'package:find_a_cat/assets/constants.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'signup.dart';

class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  TextEditingController usernameUser = TextEditingController();
  TextEditingController passwordUser = TextEditingController();
  bool showError = false;

  @override
  Widget build(BuildContext context) {
    String? token;

    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg_login.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(50, 30, 50, 0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                    height: 179, child: Image.asset('assets/images/Logo_md.png')),
                SizedBox(
                    height: 56, child: Image.asset('assets/images/logomark.png')),
                const SizedBox(height: 90),
                SizedBox(
                  height: 60,
                  width: 260,
                  child: TextField(
                    controller: usernameUser,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.all(25.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(
                          color: Color(0xFFBEBEBE),
                          width: 1,
                          style: BorderStyle.solid,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 60,
                  width: 260,
                  child: TextField(
                    controller: passwordUser,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.all(25.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(
                          color: Color(0xFFBEBEBE),
                          width: 1,
                          style: BorderStyle.solid,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Visibility(
                  visible: showError,
                  child: const Text(
                    'Credenciais inválidas. Por favor, tente novamente.',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  height: 50,
                  width: 260,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color(0xFFFF9C51)),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          side: const BorderSide(
                              width: 1, color: Color(0xFFE97F2E)),
                        ))),
                    onPressed: () {
                      setState(() {
                        login(usernameUser.text, passwordUser.text).then((value) {
                          token = value;
                          if (token != null) {
                            saveToken(token!, usernameUser.text).then((value) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HomePage(),
                                  ));
                            });
                          } else {
                            showError = true;
                          }
                        });
                      });
                    },
                    child: const Text(
                      'Entrar',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Não tem conta?",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    TextButton(
                      style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        // side: BorderSide(width: 1, color: Color(0xFFE97F2E)),
                      ))),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Signup(),
                            ));
                      },
                      child: const Text(
                        'Cadastrar',
                        style: TextStyle(
                            color: Color(0xFFE97F2E),
                            decoration: TextDecoration.underline),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<String?> login(String username, String password) async {
    // final uri = Uri.parse("https://jsonplaceholder.typicode.com/posts");
    // final uri = Uri.parse("http://192.168.1.5:8080/auth/login");
    // final uri = Uri.parse("http://172.23.96.1:8080/auth/login");
    final uri = Uri.parse("$API_URL/auth/login");
    final Map<String, dynamic> request = {
      'username': username,
      'password': password,
    };
    Map<String, String> headers = {'content-type': "application/json"};
    final response =
        await http.post(uri, headers: headers, body: jsonEncode(request));

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final String token = responseData['token'];
      print("responseData['token']");
      return token;
    } else {
      String? token = null;
      return token;
    }
  }

  Future<void> saveToken(String token, String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userToken', token);
    await prefs.setString('username', username);
  }

  Future push(BuildContext context, Widget page, {bool flagBack = true}) {
    if (flagBack) {
      // Pode voltar, ou seja, a página é adicionada na pilha.
      return Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return page;
      }));
    } else {
      // Não pode voltar, ou seja, a página nova substitui a página atual.
      return Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return page;
      }));
    }
  }
}
