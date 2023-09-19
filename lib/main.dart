import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/cat_data.dart';
import 'pages/signin.dart';
import 'dart:io';

//FIREBASE
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CatData(),
      builder: (context, child) =>  MaterialApp(
        theme: ThemeData(fontFamily: "Inter"),
        debugShowCheckedModeBanner: false,
        home: Signin(),
      ),
    );
  }
}
