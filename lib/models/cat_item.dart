import 'dart:io';
import 'package:geolocator/geolocator.dart';

class CatItem {

  final String name;
  final String title;
  final String description;
  final File? image;
  final DateTime dateTime;
  final Position? location;

  CatItem({
    required this.name,
    required this.title,
    required this.description,
    required this.image,
    required this.dateTime,
    required this.location,
  });
}
