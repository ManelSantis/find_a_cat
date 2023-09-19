import 'dart:convert';

import 'package:find_a_cat/assets/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cat_item.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:http/http.dart' as http;
class CatMap extends StatefulWidget {
  final List<CatItem> catData;

  const CatMap({Key? key, required this.catData}) : super(key: key);

  @override
  State<CatMap> createState() => _CatMapState();
}

class _CatMapState extends State<CatMap> {
  LatLng currentPosition = LatLng(0, 0);

  List<CatItem>? gatos;



  void initState() {
    super.initState();
    // Chame sua função aqui
    fetchCatList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mapa de Gatos'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[Color(0xFFE97F2E), Color(0xFFFF9C51)]),
          ),
        ),
      ),
      body: FutureBuilder<LatLng?>(
        future: _getCurrentPosition(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // Mostra um indicador de carregamento enquanto aguarda a localização.
          } else if (snapshot.hasError) {
            return Text('Erro ao obter a localização');
          } else if (snapshot.hasData) {
            final LatLng? currentPosition = snapshot.data;
            if (currentPosition != null) {
              return FlutterMap(
                options: MapOptions(
                  center: currentPosition,
                  zoom: 16.2,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.app',
                  ),
                  MarkerLayer(
                    // markers: widget.catData.map((cat) {
                    markers: gatos!.map((cat) {
                      return Marker(
                        point: cat.latitude != null && cat.longitude != null
                            ? LatLng(cat.latitude!, cat.longitude!)
                            : LatLng(0, 0),
                        width: 20,
                        height: 20,
                        builder: (context) => FlutterLogo(),
                      );
                    }).toList(),
                  ),
                  //CurrentLocationLayer(),
                ],
              );
            }
          }
          return Text('Localização não disponível');
        },
      ),
    );
  }

  Future<LatLng?> _getCurrentPosition() async {
    try {
      final Position? position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      if (position != null) {
        return LatLng(position.latitude, position.longitude);
      }
    } catch (e) {
      print('Erro ao obter a posição: $e');
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
          setState(() {
            gatos = catList;
          });
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
}
