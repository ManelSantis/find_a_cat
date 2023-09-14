import 'package:find_a_cat/components/CatMap.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/cat_data.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CatData(),
      builder: (context, child) => const MaterialApp(
        debugShowCheckedModeBanner: false,
        // home: HomePage(),
        home: CatMap(),
      ),
    );
  }
}
