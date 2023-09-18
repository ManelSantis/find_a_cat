import 'dart:io';

import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/foundation.dart';

class StorageClient {
  final storage = firebase_storage.FirebaseStorage.instance;

  //send image to firebase
  Future<String?> uploadImageToFirebase({
    required File imageFile,
  }) async {
    try {
      String filePath = imageFile.path;
      File file = File(filePath);

      // TODO auth será necessário apenas em produção
      //await FirebaseAuth.instance.signInAnonymously();
      try {
        String? path;
        String uniqueKey = UniqueKey().toString();
        String fileExtension = filePath.split('.').last;

        path = 'uploads/cat_$uniqueKey.$fileExtension';

        firebase_storage.Reference reference =
        firebase_storage.FirebaseStorage.instance.ref(path);
        // upload

        await reference.putFile(file);

        print("ALOOOOOOOOOO 444444 chegou aqui");

        // get uploaded object link
        String image = await reference.getDownloadURL();
        return image;
      } on firebase_core.FirebaseException catch (e) {
        print(e.stackTrace.toString());
      }
    } catch (e) {
      print(e.toString());
    }

    return null;
  }
}
