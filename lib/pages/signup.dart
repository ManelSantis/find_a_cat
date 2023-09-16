import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/user.dart';

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
      appBar: AppBar(
        title: Text('Cadastro'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: nameUser,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: usernameUser,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: emailUser,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordUser,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            TextField(
              controller: confirmPasswordUser,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Confirm Password'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {

                  user = createUser(nameUser.text, usernameUser.text, emailUser.text, passwordUser.text);

                });
              },
              child: Text('Concluir'),
            ),
          ],
        ),
      ),
    );
  }

  Future<User> createUser(String name, String username, String email, String password) async {
      Map<String, dynamic> request = {
        'name': name,
        'username': username,
        'email': email,
        'password': password
      };

      final uri = Uri.parse("https://jsonplaceholder.typicode.com/posts");
      final response = await http.post(uri, body: request);

      if (response.statusCode == 201){
        print(response.body);
        return User.fromJson(json.decode(response.body));
      } else {
        throw Exception('Falied');
      }
  }
}