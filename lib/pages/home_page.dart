import 'dart:io';
import 'package:flutter/material.dart';
import '../data/cat_data.dart';
import '../models/cat_item.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'cat_description.dart';
import 'package:geolocator/geolocator.dart';
import 'package:find_a_cat/components/CatMap.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();

}

class _HomePageState extends State<HomePage> {
  final nameCat = TextEditingController();
  final titleCat = TextEditingController();
  final descriptionCat = TextEditingController();
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
                    controller: nameCat,
                    decoration: const InputDecoration(hintText: 'Nome'),
                  ),
                  TextField(
                    controller: titleCat,
                    decoration: const InputDecoration(hintText: 'Título'),
                  ),
                  TextField(
                    controller: descriptionCat,
                    decoration: const InputDecoration(hintText: 'Descrição'),
                  ),
                ],
              ),
              actions: [
                MaterialButton(onPressed: save, child: Text('Adicionar')),
                MaterialButton(onPressed: cancel, child: Text('Cancelar')),
              ],
            ));
  }

  void save() async {
    final Position? location = await _getCurrentPosition();
    if (location != null) {

      CatItem cat = CatItem(
          name: nameCat.text,
          title: titleCat.text,
          description: descriptionCat.text,
          image: imageFile,
          dateTime: DateTime.now(),
          location: location
      );
      Provider.of<CatData>(context, listen: false).addNewCat(cat);
    }
    clear();
    Navigator.pop(context);
  }

  void cancel() {
    clear();
    Navigator.pop(context);
  }

  void clear() {
    nameCat.clear();
    imageFile = null;
    titleCat.clear();
    descriptionCat.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CatData>(
      builder: (context, value, child) => Scaffold(
          backgroundColor: Colors.grey[300],
          floatingActionButton:
          Row(
              children: [
                SizedBox(width: 140),
                FloatingActionButton(
            onPressed: addNewCat,
            backgroundColor: Colors.blue[300],
            child: Icon(Icons.add),
          ),
                SizedBox(width: 16),
                FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CatMap(catData: Provider.of<CatData>(context).getAllCatsList()),
                  ),
                ); },
                  backgroundColor: Colors.green[300],
                child: Icon(Icons.map),
               ),
                ],
          ),
          body:
              ListView.builder(
                itemCount: value.getAllCatsList().length,
                itemBuilder: (context, index) => ListTile(
                  title: Text('${value.getAllCatsList()[index].title} , ${value.convertDateTimeToString(value.getAllCatsList()[index].dateTime)}'),
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

  Future <Position?> _getCurrentPosition() async {
    try {
      final Position? position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high,);
      if (position != null) {
          return position;
      } else {
        print("Posição não disponível");
      }
    } catch (e) {
      print('Erro ao obter a posição: $e');
    }
  }
}

