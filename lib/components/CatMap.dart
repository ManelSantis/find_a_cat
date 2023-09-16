import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/cat_item.dart';
import 'package:geolocator/geolocator.dart';


class CatMap extends StatefulWidget {
  final List<CatItem> catData;

  const CatMap({Key? key, required this.catData}) : super(key: key);
  @override
  State<CatMap> createState() => _CatMapState();
}

class _CatMapState extends State<CatMap> {
  LatLng currentPosition = LatLng(0, 0);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mapa de Gatos'),
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
                  zoom: 9.2,
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.app',
                  ),
                  MarkerLayer(
                    markers: widget.catData.map((cat) {
                      return Marker(
                        point: cat.latitude != null && cat.longitude != null
                            ? LatLng(cat.latitude, cat.longitude)
                            : LatLng(0, 0),
                        width: 20,
                        height: 20,
                        builder: (context) => FlutterLogo(),
                      );
                    }).toList(),
                  ),
                ],
              );
            }
          }
          return Text('Localização não disponível');
        },
      ),
    );
  }
  Future <LatLng?> _getCurrentPosition() async {
    try {
      final Position? position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high,);
      if (position != null) {
        return LatLng(position.latitude, position.longitude);
      }
    } catch (e) {
      print('Erro ao obter a posição: $e');
    }
  }

}
