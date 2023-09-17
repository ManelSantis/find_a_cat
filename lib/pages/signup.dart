import 'dart:convert';
import 'package:find_a_cat/assets/constants.dart';
import 'package:find_a_cat/pages/signin.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import 'dart:convert';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController nameUser = TextEditingController();
  TextEditingController usernameUser = TextEditingController();
  TextEditingController emailUser = TextEditingController();
  TextEditingController passwordUser = TextEditingController();
  TextEditingController confirmPasswordUser = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Future<User?>? user;

    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Cadastro'),
      // ),
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg_cad.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(50, 40, 50, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                  height: 150, child: Image.asset('assets/images/logo_sm.png')),
              SizedBox(height: 40),
              SizedBox(
                height: 60,
                width: 260,
                child: TextField(
                  controller: nameUser,
                  decoration: InputDecoration(
                    labelText: 'Name',
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
              const SizedBox(height: 8),
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
              const SizedBox(height: 8),
              SizedBox(
                height: 60,
                width: 260,
                child: TextField(
                  controller: emailUser,
                  decoration: InputDecoration(
                    labelText: 'Email',
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
              const SizedBox(height: 8),
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
              const SizedBox(height: 8),
              SizedBox(
                height: 60,
                width: 260,
                child: TextField(
                  controller: confirmPasswordUser,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
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
              const SizedBox(height: 16),
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
                      user = createUser(nameUser.text, usernameUser.text,
                          emailUser.text, passwordUser.text);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Signin(),
                          ));
                    });
                  },
                  child: Text('Concluir'),
                ),
              ),
              SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Já tem conta?",
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
                            builder: (context) => Signin(),
                          ));
                    },
                    child: const Text(
                      'Entrar',
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
    );
  }

  Future<User> createUser(
      String name, String username, String email, String password) async {
    Map<String, dynamic> request = {
      'name': name,
      'username': username,
      'email': email,
      'password': password
    };
    Map<String, String> headers = {'content-type': "application/json"};
    //final uri = Uri.parse("http://192.168.1.5:8080/user/register");
    final uri = Uri.parse("$API_URL/user/register");
    debugPrint(request.toString());

    final response =
        await http.post(uri, headers: headers, body: jsonEncode(request));

    if (response.statusCode == 201) {
      print(response.body);

      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Falied');
    }
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
