import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageBloc {
  final storage = FirebaseStorage.instance.ref();

  Future<String> uploadExerciseImg(File img) async {
    final result = await FirebaseStorage.instance.ref().child("/exerciseIMG/${img.hashCode}").putFile(img).onComplete;
    return await result.ref.getPath();
  }

  Future<String> getFileURL(String path) async {
    return await storage.child(path).getDownloadURL();
  }

  Future deleteImg(String path) async {
    return await storage.child(path).delete();
  }
}
