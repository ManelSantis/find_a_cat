import 'dart:io';

import 'user.dart';

class CatItem {
  int? id;
  String? name;
  String? title;
  String? description;

  //final File? image;
  String? image;
  DateTime? dateTime;
  double? latitude;
  double? longitude;
  User? user;

  CatItem(
      {required this.id,
      required this.name,
      required this.title,
      required this.description,
      required this.image,
      required this.dateTime,
      required this.latitude,
      required this.longitude,
      required this.user});

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

  factory CatItem.fromJson(Map<String, dynamic> json) {
    return CatItem (
    id: json['id'],
    title: json['title'],
    name: json['name'],
    description: json['description'],
    dateTime: DateTime.parse(json['date']),
    image: json['picture'],
    latitude: json['latitude'],
    longitude: json['longitude'],
    user: User.fromJson(json['user'])
    );
  }
}
