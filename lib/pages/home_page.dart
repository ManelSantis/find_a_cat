import 'dart:io';
import 'dart:convert';
import 'package:find_a_cat/assets/constants.dart';
import 'package:find_a_cat/firebase/storage.dart';
import 'package:find_a_cat/models/user.dart';
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
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

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
  String pathImg = "";
  User? loggedUser;

  @override
  void initState() {
    super.initState();
    // Chame sua função aqui
    fetchUser();
  }
  void addNewCat() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Encontrei um novo gato'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  imageFile != null
                      ? Image.file(
                          imageFile!,
                          width: 100,
                          height: 100,
                          // fit: BoxFit.cover,
                          fit: BoxFit.fitWidth,
                        )
                      : const Icon(Icons.image),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: _getFromCamera,
                    child: const Icon(Icons.add),
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
                TextButton(
                    onPressed: cancel,
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      // side: const BorderSide(
                      //     width: 0, color:  Color(0xFF058B9C)),
                    ))),
                    child: const Text(
                      'Cancelar',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF058B9C)),
                    )),
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color(0xFFFF9C51)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          side: const BorderSide(
                              width: 1, color: Color(0xFFE97F2E)),
                        ))),
                    onPressed: save,
                    child: const Text('Adicionar')),
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
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 72,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "${loggedUser?.name}",
                    style: const TextStyle(fontWeight: FontWeight.w600),
                    softWrap: false,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text("${loggedUser?.username}",
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w400),
                      softWrap: false,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis)
                ],
              ),
              IconButton(
                iconSize: 40,
                icon: const Icon(Icons.account_circle),
                onPressed: () {
                  // ...
                },
              ),
            ],
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[Color(0xFFE97F2E), Color(0xFFFF9C51)]),
            ),
          ),
        ),
        backgroundColor: Colors.grey[300],
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(
              height: 42,
              width: 42,
              child: FloatingActionButton(
                heroTag: "viewMap",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CatMap(
                          catData:
                              Provider.of<CatData>(context).getAllCatsList()),
                    ),
                  );
                },
                backgroundColor: const Color(0xFF2ED4E9),
                child: const Icon(Icons.map),
              ),
            ),
            const SizedBox(width: 16),
            SizedBox(
              height: 65,
              width: 65,
              child: FloatingActionButton(
                heroTag: "addCat",
                onPressed: addNewCat,
                backgroundColor: const Color(0xFFE97F2E),
                child: const Icon(Icons.add, size: 40),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: FutureBuilder<List<CatItem>>(
            future: fetchCatList(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator(); // Exibe um indicador de carregamento enquanto os dados estão sendo buscados
              } else if (snapshot.hasError) {
                return Text('Erro: ${snapshot.error}');
              } else if (!snapshot.hasData) {
                return Text('Nenhum dado disponível');
              } else {
                final catList = snapshot.data!;
                return SingleChildScrollView(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: catList.length,
                    itemBuilder: (context, index) => Container(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                                        child: Icon(Icons.account_circle,size: 40, color:Colors.grey,),
                                      ),
                                      Text(
                                        "${catList[index].user!.name}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16),
                                        softWrap: false,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                  Text(
                                    value.convertDateTimeToString(
                                        catList[index].dateTime!),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 14,
                                        color: Colors.black45),
                                    softWrap: false,
                                    maxLines: 6,
                                    overflow: TextOverflow.ellipsis,
                                  )
                                ]),
                          ),
                          Container(
                              width: 390,
                              child: Image.network(
                                catList[index].image!,
                                fit: BoxFit.cover,
                              )),
                          Row(children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 4, 0, 0),
                              child: Text(
                                '${catList[index].title}',
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black45),
                                softWrap: false,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ]
                              // onTap: () async {
                              //   late Widget page = CatDescription(index: index);
                              //   String retorno = "";
                              //   try {
                              //     retorno = await push(context, page);
                              //   } catch (error) {
                              //     print(retorno);
                              //   }
                              // },
                              ),
                          Row(children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 4, 0, 0),
                              child: Text(
                                '${catList[index].name}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                                softWrap: false,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ]),
                          Padding(
                              padding: const EdgeInsets.fromLTRB(16, 4, 0, 0),
                              child: Align(
                                alignment: Alignment.bottomLeft,
                                child: Text(
                                  '${catList[index].description}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                  ),
                                  softWrap: false,
                                  maxLines: 6,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )),
                          const Divider()
                        ],
                      ),
                    ),
                  ),
                );
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
        maxWidth: 500,
        maxHeight: 500,
        imageQuality: 80,
        preferredCameraDevice: CameraDevice.front);

    setState(() {
      imageFile = File(pickedFile!.path);
      //pathImg = pickedFile!.path;
    });
    // if (imageFile != null) {
    //   String? imageLink = await StorageClient()
    //       .uploadImageToFirebase(imageFile: imageFile!);
    //   print(imageLink!);
    // }
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

  Future<Position?> _getCurrentPosition() async {
    try {
      final Position? position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      if (position != null) {
        return position;
      } else {
        print("Posição não disponível");
      }
    } catch (e) {
      print('Erro ao obter a posição: $e');
    }
  }

  Future<CatItem> createCat(String name, String title, String description,
      DateTime dateTime, int image, double latitude, double longitude) async {
    try {
      //final uri = Uri.parse("http://192.168.1.5:8080/cat/create");
      final uri = Uri.parse("$API_URL/cat/create");
      final String formattedDateTime =
          DateFormat("yyyy-MM-ddTHH:mm:ss").format(dateTime);

      final token = await getToken();
      final username = await getUsername();
      //final userUri = Uri.parse("http://192.168.1.5:8080/user/username/$username");
      final userUri = Uri.parse("$API_URL/user/username/$username");
      final responseUser = await http.get(userUri, headers: {
        'content-type': "application/json",
        'authorization': "Bearer $token"
      });

      String imgUrl = "";
      if (imageFile != null) {
        String? imageLink =
            await StorageClient().uploadImageToFirebase(imageFile: imageFile!);
        print(imageLink!);
        imgUrl = imageLink!;
      }
      if (responseUser.statusCode == 200) {
        final userData = json.decode(responseUser.body);
        final Map<String, dynamic> request = {
          'name': name,
          'title': title,
          'description': description,
          'date': formattedDateTime,
          'picture': imgUrl,
          'latitude': latitude,
          'longitude': longitude,
          'user': {
            'id': userData['id'],
            'name': userData['name'],
            'username': userData['username'],
            'email': userData['email']
          },
        };
        filepathToBas64(pathImg);
        final headers = {
          'content-type': "application/json",
          'authorization': "Bearer $token",
        };

        final response =
            await http.post(uri, headers: headers, body: json.encode(request));

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
      throw ('Erro: $e');
    }
  }

  Future<List<CatItem>> fetchCatList() async {
    //final uri = Uri.parse("http:/192.168.1.5:8080/cat/paged");
    final uri = Uri.parse("$API_URL/cat/paged");

    try {
      final token = await getToken();
      final response = await http.get(uri, headers: {
        'content-type': "application/json",
        'authorization': "Bearer $token",
      });

      if (response.statusCode == 200) {
        if (response.body != null && response.body.isNotEmpty) {
          final Map<String, dynamic> jsonBody = json.decode(response.body);
          final List<dynamic> catJsonList =
              jsonBody['content'] as List<dynamic>;
          final List<CatItem> catList =
              catJsonList.map((catJson) => CatItem.fromJson(catJson)).toList();

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

  void filepathToBas64(String imgPath) async {
    File imagefile = File(imgPath);
    Uint8List imagebytes = await imagefile.readAsBytes(); //convert to bytes
    String base64string =
        base64.encode(imagebytes); //convert bytes to base64 string
    print(base64string);
  }

  Future<User?> fetchUser() async {
    //final uri = Uri.parse("http:/192.168.1.5:8080/cat/paged");
    final token = await getToken();
    final username = await getUsername();
    //final userUri = Uri.parse("http://192.168.1.5:8080/user/username/$username");
    final userUri = Uri.parse("$API_URL/user/username/$username");
    final responseUser = await http.get(userUri, headers: {
      'content-type': "application/json",
      'authorization': "Bearer $token"
    });
    if (responseUser.statusCode == 200) {
      final userData = json.decode(responseUser.body);
      final Map<String, dynamic> request = {
        'id': userData['id'],
        'name': userData['name'],
        'username': userData['username'],
        'email': userData['email']
      };
      User u = User.fromJson(request);
      setState(() {
        loggedUser = u;
      });
      return u;
    }
  }
}
