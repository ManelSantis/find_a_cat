import 'dart:io';

class CatItem {
  //Foto
  final String title;
  final String description;
  final File? image;
  final DateTime dateTime;
  final String location;

  CatItem({
    required this.title,
    required this.description,
    required this.image,
    required this.dateTime,
    required this.location,
  });
}
