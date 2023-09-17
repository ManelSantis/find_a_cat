import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import '../data/cat_data.dart';
import '../models/cat_item.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'cat_description.dart';
import 'package:geolocator/geolocator.dart';
import 'package:find_a_cat/components/CatMap.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

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
      try {
        final cat = await createCat(
            nameCat.text,
            titleCat.text,
            descriptionCat.text,
            DateTime.now(),
            123,
            location.latitude,
            location.longitude);

        Provider.of<CatData>(context, listen: false).addNewCat(cat);
      } catch (e) {
        // Lide com erros ao criar o gato
        print('Erro ao criar o gato: $e');
      }
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
          FutureBuilder<List<CatItem>>(
            future: fetchCatList(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator(); // Exibe um indicador de carregamento enquanto os dados estão sendo buscados
              } else if (snapshot.hasError) {
                return Text('Erro: ${snapshot.error}');
              } else if (!snapshot.hasData) {
                return Text('Nenhum dado disponível');
              } else {
                final catList = snapshot.data!;

                return ListView.builder(
                  itemCount: catList.length,
                  itemBuilder: (context, index) => ListTile(
                    title: Text('${catList[index].title} , ${value.convertDateTimeToString(catList[index].dateTime!)}'),
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
                );
              }
            },
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

  Future<CatItem> createCat (String name, String title, String description, DateTime dateTime, int image, double latitude, double longitude) async {
    try {
      //final uri = Uri.parse("http://192.168.1.5:8080/cat/create");
      final uri = Uri.parse("http://172.23.96.1:8080/cat/create");
      final String formattedDateTime = DateFormat("yyyy-MM-ddTHH:mm:ss").format(dateTime);

      final token = await getToken();
      final username = await getUsername();
      //final userUri = Uri.parse("http://192.168.1.5:8080/user/username/$username");
      final userUri = Uri.parse("http://172.23.96.1:8080/user/username/$username");
      final responseUser = await http.get(userUri, headers: {'content-type': "application/json", 'authorization': "Bearer $token"});

      if (responseUser.statusCode == 200) {
        final userData = json.decode(responseUser.body);
        final Map<String, dynamic> request = {
          'name': name,
          'title': title,
          'description': description,
          'date': formattedDateTime,
          'picture': image,
          'latitude': latitude,
          'longitude': longitude,
          'user': {
            'id': userData['id'],
            'name': userData['name'],
            'username': userData['username'],
            'email': userData['email']
          },
        };

        final headers = {
          'content-type': "application/json",
          'authorization': "Bearer $token",
        };

        final response = await http.post(uri, headers: headers, body: json.encode(request));

        if (response.statusCode == 201) {
          debugPrint(response.body);
          Map<String, dynamic> jsonData = json.decode(response.body.toString());
          debugPrint(jsonData.toString());
          CatItem cat = CatItem.fromJson(jsonData);
          return cat;
        } else {
          throw Exception('Falha ao criar o gato');
        }
      } else {
        throw Exception('Falha ao obter os dados do usuário');
      }
    } catch (e, stackTrace) {
      throw('Erro: $e');
    }

  }

  Future<List<CatItem>> fetchCatList() async {
    //final uri = Uri.parse("http:/192.168.1.5:8080/cat/paged");
    final uri = Uri.parse("http://172.23.96.1:8080/cat/paged");

    try {
      final token = await getToken();
      final response = await http.get(uri, headers: {
        'content-type': "application/json",
        'authorization': "Bearer $token",
      });

      if (response.statusCode == 200) {
        if (response.body != null && response.body.isNotEmpty) {
          final Map<String, dynamic> jsonBody = json.decode(response.body);
          final List<dynamic> catJsonList = jsonBody['content'] as List<dynamic>;
          final List<CatItem> catList = catJsonList.map((catJson) => CatItem.fromJson(catJson)).toList();

          return catList;
        } else {
          throw Exception('Empty response body');
        }
      } else {
        throw Exception('Falha ao buscar a lista de gatos');
      }
    } catch (e, stackTrace) {
      print('Erro: $e');
      print('Stack Trace: $stackTrace');
      throw e; // Rethrow a exceção para que o chamador saiba que algo deu errado
    }

  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userToken');
  }

  Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }
}

