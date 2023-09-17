import 'dart:io';

import 'user.dart';

class CatItem {
  final int id;
  final String name;
  final String title;
  final String description;
  //final File? image;
  final int image;
  final DateTime dateTime;
  final double latitude;
  final double longitude;
  final User user;

  CatItem({
    required this.id,
    required this.name,
    required this.title,
    required this.description,
    required this.image,
    required this.dateTime,
    required this.latitude,
    required this.longitude,
    required this.user
  });

  factory CatItem.createCat(Map<String, dynamic> json) => CatItem(
      id: json['id'],
      name: json['name'],
      title: json['title'],
      description: json['description'],
      image: json['picture'],
      dateTime: json['date'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      user: json['user']
  );
}
