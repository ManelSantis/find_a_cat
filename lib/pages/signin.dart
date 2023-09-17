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
      body: Container(
        decoration:const  BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg_login.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset('assets/images/Logo_md.png'),
              Image.asset('assets/images/logomark.png'),
              TextField(
                controller: usernameUser,
                decoration: InputDecoration(labelText: 'Username'),
              ),
              TextField(
                controller: passwordUser,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Password'),
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
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    login(usernameUser.text, passwordUser.text).then((value) {
                      token = value;
                      if (token != null) {
                        saveToken(token!, usernameUser.text);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomePage(),
                            )
                        );
                      } else {
                        showError = true;
                      }
                    });
                  });
                },
                child: Text('Entrar'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Signup(),
                      )
                  );
                },
                child: Text('Cadastrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String?> login(String username, String password) async {
    // final uri = Uri.parse("https://jsonplaceholder.typicode.com/posts");
    final uri = Uri.parse("http://192.168.1.5:8080/auth/login");
    // final uri = Uri.parse("http://172.23.96.1:8080/auth/login");
    final Map<String, dynamic> request = {
      'username': username,
      'password': password,
    };
    Map<String,String> headers = {
      'content-type':"application/json"
    };
    final response = await http.post(uri,headers: headers, body: jsonEncode(request));

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