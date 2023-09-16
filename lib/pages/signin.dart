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

  @override
  Widget build(BuildContext context) {
    Future<String> token;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: usernameUser,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: passwordUser,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  token = login(usernameUser.text, passwordUser.text);
                  saveToken(token as String);
                });
                Navigator.push(
                    context,
                    MaterialPageRoute(
                    builder: (context) => HomePage(),
                    )
                );
              },
              child: Text('Entrar'),
            ),
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
    );
  }

  Future<String> login(String username, String password) async {
    final uri = Uri.parse("https://jsonplaceholder.typicode.com/posts");
    final Map<String, dynamic> request = {
      'username': username,
      'password': password,
    };

    final response = await http.post(uri, body: request);

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final String token = responseData['token'];
      if (token != null) {
        return token;
      } else {
        throw Exception('Token não encontrado na resposta da API');
      }
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userToken', token);
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