import 'dart:io';
import 'package:flutter/material.dart';
import '../data/cat_data.dart';
import '../models/cat_item.dart';
import 'package:provider/provider.dart';

class CatDescription extends StatefulWidget {
  final int index;
  const CatDescription({required this.index});

  @override
  State<CatDescription> createState() => _CatDescriptionState();

}

class _CatDescriptionState extends State<CatDescription> {
  @override
  Widget build(BuildContext context) {
    final catData = Provider.of<CatData>(context);
    final index = widget.index;
    final catItem = catData.getByIndex(index);

    return Scaffold(
      appBar: AppBar(
        title: Text('Descrição do Gato'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.file(
              catItem.image!,
              width: 360,
              height: 360,
              fit: BoxFit.cover,
            ),
            Text('Nome: ${catItem.title}'),
            Text('Descrição: ${catItem.description}'),
            Text('Data: ${catData.convertDateTimeToString(catItem.dateTime)}'),
          ],
        ),
      ),
    );
  }
}