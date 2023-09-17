import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/cat_data.dart';
import 'pages/signin.dart';

void main() {
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
