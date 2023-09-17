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
      id: json['id'] as int,
      name: json['name'],
      title: json['title'],
      description: json['description'],
      image: json['picture'],
      dateTime: json['date'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      user: json['user']);

//   factory CatItem.fromJson( Map<String, dynamic> json) {
//     return CatItem(
//         id: json['id'],
// >>>>>>> 9a86b985cdfc277cee9e1339180be552bb20c051
//         name: json['name'],
//         title: json['title'],
//         description: json['description'],
//         image: json['picture'],
//         dateTime: json['date'],
//         latitude: json['latitude'],
//         longitude: json['longitude'],
// <<<<<<< HEAD
//         // user: json['user']
//         user: User.fromJson(json['user']),
//       );

  CatItem.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int;
    print(json['id']);
    title = json['title'];
    print(json['title']);
    name = json['name'];
    print(json['name']);
    description = json['description'];
    print(json['description']);
    dateTime =
        DateTime.parse("${json['date'].toString().replaceAll("T", " ")}Z");
    print(json['date']);
    image = json['picture'];
    print(json['picture']);
    latitude = (json['latitude'] as num?)?.toDouble();
    print(json['latitude']);
    longitude = (json['longitude'] as num?)?.toDouble();
    print(json['longitude']);
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }
}
