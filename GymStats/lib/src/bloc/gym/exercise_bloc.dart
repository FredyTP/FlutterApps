import 'dart:io';

import 'package:GymStats/src/bloc/storage_bloc.dart';
import 'package:GymStats/src/model/exercise_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ExerciseBloc {
  final _collection = FirebaseFirestore.instance.collection("exercises");
  StorageBloc _storageBloc;
  void init(StorageBloc storageBloc) {
    _storageBloc = storageBloc;
  }

  Stream<QuerySnapshot> getExercisesStream() {
    return _collection.snapshots().asBroadcastStream();
  }

  Future addExersice(ExerciseModel exercise) async {
    return await _collection.add(exercise.toJson());
  }

  Future updateExercise(ExerciseModel exerciseModel) async {
    return await _collection.doc(exerciseModel.id).update(exerciseModel.toJson());
  }

  Future deleteExercise(ExerciseModel exerciseModel) async {
    if (exerciseModel.imagePath != null) await _storageBloc.deleteImg(exerciseModel.imagePath);
    return await _collection.doc(exerciseModel.id).delete();
  }

  Future<ExerciseModel> getExercise(String id) async {
    final result = await _collection.doc(id).get();
    if (result.exists == false) return null;
    return ExerciseModel.fromFirebase(result);
  }

  Future<File> pickImageFromGallery() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedFile == null) {
      return null;
    }
    return await ImageCropper.cropImage(
      sourcePath: pickedFile.path,
      aspectRatio: CropAspectRatio(ratioX: 5, ratioY: 3),
      compressFormat: ImageCompressFormat.png,
      compressQuality: 100,
      androidUiSettings: AndroidUiSettings(
        statusBarColor: Color.fromRGBO(0, 0, 0, 1),
        toolbarTitle: "Edita la imagen",
        toolbarColor: Color.fromRGBO(0, 0, 0, 1),
        toolbarWidgetColor: Color.fromRGBO(255, 255, 255, 1),
      ),
    );
  }
}
