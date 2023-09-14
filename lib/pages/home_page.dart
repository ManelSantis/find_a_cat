import 'dart:io';
import 'package:flutter/material.dart';
import '../data/cat_data.dart';
import '../models/cat_item.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'cat_description.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();

}

class _HomePageState extends State<HomePage> {
  final titleCat = TextEditingController();
  final descriptionCat = TextEditingController();
  final locationCat = TextEditingController();
  ImagePicker imagePicker = ImagePicker();
  File? imageFile;

  void addNewCat() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Encontrei um novo gato'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  imageFile != null ?
                  Image.file(
                      imageFile!,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ) : Icon(Icons.image),
                  SizedBox(height: 20),
                  TextButton(
                      onPressed: _getFromCamera,
                      child: Icon(Icons.add),
                  ),
                  TextField(
                    controller: titleCat,
                    decoration: const InputDecoration(hintText: 'Título'),
                  ),
                  TextField(
                    controller: descriptionCat,
                    decoration: const InputDecoration(hintText: 'Descrição'),
                  ),
                  TextField(
                    controller: locationCat,
                    decoration: const InputDecoration(hintText: 'Local'),
                  ),
                ],
              ),
              actions: [
                MaterialButton(onPressed: save, child: Text('Adicionar')),
                MaterialButton(onPressed: cancel, child: Text('Cancelar')),
              ],
            ));
  }

  void save() {
    CatItem cat = CatItem(
        title: titleCat.text,
        description: descriptionCat.text,
        image: imageFile,
        dateTime: DateTime.now(),
        location: locationCat.text);
    Provider.of<CatData>(context, listen: false).addNewCat(cat);
    clear();
    Navigator.pop(context);
  }

  void cancel() {
    clear();
    Navigator.pop(context);
  }

  void clear() {
    imageFile = null;
    titleCat.clear();
    descriptionCat.clear();
    locationCat.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CatData>(
      builder: (context, value, child) => Scaffold(
          backgroundColor: Colors.grey[300],
          floatingActionButton: FloatingActionButton(
            onPressed: addNewCat,
            backgroundColor: Colors.green[300],
            child: Icon(Icons.add),
          ),
          body:
              ListView.builder(
                itemCount: value.getAllCatsList().length,
                itemBuilder: (context, index) => ListTile(
                  title: Text('${value.getAllCatsList()[index].title} , '
                      '${value.convertDateTimeToString(value.getAllCatsList()[index].dateTime)}'),
                  onTap: () async {
                    late Widget page = CatDescription(index: index);
                    String retorno = "";
                    try {
                      retorno = await push(context, page);
                    } catch (error) {
                      print(retorno);
                    }
                  },
                ),
              ),
           ),
    );
  }

  void _getFromCamera() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: 360,
      maxHeight: 360,
        imageQuality: 50,
        preferredCameraDevice: CameraDevice.front
    );

    setState(() {
      imageFile = File(pickedFile!.path);
    });
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

