import 'dart:convert';

import 'package:find_a_cat/assets/constants.dart';

import 'package:find_a_cat/models/user.dart';

import 'package:flutter/material.dart';
import '../data/cat_data.dart';
import '../models/cat_item.dart';
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class MyPost extends StatefulWidget {
  @override
  State<MyPost> createState() => _MyPostState();
}

class _MyPostState extends State<MyPost> {
  User? loggedUser;

  @override
  void initState() {
    super.initState();
    // Chame sua função aqui
    fetchUser();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CatData>(
        builder: (context, value, child) => Scaffold(
              appBar: AppBar(
                title: const Text('Meus Gatos'),
                toolbarHeight: 72,
                flexibleSpace: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: <Color>[Color(0xFFE97F2E), Color(0xFFFF9C51)]),
                  ),
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: FutureBuilder<List<CatItem>>(
                  future: fetchMyCatList(),
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
                                            const Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 0, 4, 0),
                                              child: Icon(
                                                Icons.account_circle,
                                                size: 40,
                                                color: Colors.grey,
                                              ),
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
                                    padding:
                                        const EdgeInsets.fromLTRB(16, 4, 0, 0),
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
                                    padding:
                                        const EdgeInsets.fromLTRB(16, 4, 0, 0),
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
                                    padding:
                                        const EdgeInsets.fromLTRB(16, 4, 0, 0),
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
                                TextButton(
                                  onPressed: () => showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) => Dialog(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            const Text(
                                              'Tem certeza que deseja deletar seu post? '
                                              'esta operação é PERMANENTE!!!.',
                                              softWrap: false,
                                              maxLines: 4,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 15),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                TextButton(
                                                  onPressed: () {
                                                    deleteCat(catList[index]
                                                        .id
                                                        .toString());
                                                    Navigator.pop(context);
                                                    Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) => MyPost(),
                                                        ));
                                                  },
                                                  child: const Text(
                                                    'Sim',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color:
                                                            Color(0xFF058B9C)),
                                                  ),
                                                  style: ButtonStyle(
                                                      shape: MaterialStateProperty.all<
                                                              RoundedRectangleBorder>(
                                                          RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30.0),
                                                    // side: const BorderSide(
                                                    //     width: 0, color:  Color(0xFF058B9C)),
                                                  ))),
                                                ),
                                                ElevatedButton(
                                                  style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all<
                                                                      Color>(
                                                                  const Color(
                                                                      0xFFFF9C51)),
                                                      shape: MaterialStateProperty
                                                          .all<RoundedRectangleBorder>(
                                                              RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30.0),
                                                        side: const BorderSide(
                                                            width: 1,
                                                            color: Color(
                                                                0xFFE97F2E)),
                                                      ))),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('Não'),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.fromLTRB(0, 5, 8, 5),
                                    child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Icon(
                                          Icons.delete_forever,
                                          color: Colors.red,
                                        )),
                                  ),
                                ),
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
            ));
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

  Future<void> deleteCat(String id) async {
    final uri = Uri.parse("$API_URL/cat/$id");

    try {
      final token = await getToken();
      final response = await http.delete(uri, headers: {
        'content-type': "application/json",
        'authorization': "Bearer $token",
      });

      if (response.statusCode == 204) {
        print("Gato deletado com sucesso");
      } else {
        throw Exception('Falha deletar gato');
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

  Future<List<CatItem>> fetchCatList() async {
    //final uri = Uri.parse("http:/192.168.1.5:8080/cat/paged");
    final uri = Uri.parse("$API_URL/cat/user/${loggedUser!.id}");

    try {
      final token = await getToken();
      final response = await http.get(uri, headers: {
        'content-type': "application/json",
        'authorization': "Bearer $token",
      });

      if (response.statusCode == 200) {
        if (response.body != null && response.body.isNotEmpty) {
          final Map<String, dynamic> jsonBody = json.decode(response.body);
          print("Chegou");
          final List<dynamic> catJsonList =
              jsonBody['content'] as List<dynamic>;
          final List<CatItem> catList =
              catJsonList.map((catJson) => CatItem.fromJson(catJson)).toList();
          print("alo");
          catList.sort((a, b) => b.dateTime!.compareTo(a.dateTime!));

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

  Future<List<CatItem>> fetchMyCatList() async {
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
          catList.removeWhere((cat) => cat.user!.id != loggedUser!.id);

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
}
