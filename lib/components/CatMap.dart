import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class CatMap extends StatefulWidget {
  const CatMap({super.key});



  @override
  State<CatMap> createState() => _CatMapState();
}

class _CatMapState extends State<CatMap> {

  double lati = 0;
  double longi = 0;

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        center: LatLng(-5.2045633, -37.325531),
        // center: LatLng(51.509364, -0.128928),
        zoom: 9.2,
      ),
      nonRotatedChildren: [],
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.app',
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: LatLng(-5.2045633, -37.325531),
              width: 20,
              height: 20,
              builder: (context) => FlutterLogo(),
            ),
          ],
        ),
        CurrentLocationLayer()
      ],
    );
  }

  Future<Position> _getCurrentPosition() async {
    final position = await Geolocator.getLastKnownPosition();
    if (position != null) {
      return position;
    }

  }
}
