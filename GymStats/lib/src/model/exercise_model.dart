import 'package:GymStats/src/model/muscle_enum.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ExerciseModel {
  final String imageURL;
  final String description;
  final String name;
  final String id;
  final List<Muscles> primaryMuscles;
  final List<Muscles> secondaryMuscles;

  ExerciseModel({this.imageURL, this.description, this.name, this.primaryMuscles, this.secondaryMuscles, this.id});

  ExerciseModel.fromJson(Map<String, dynamic> json)
      : imageURL = json['imageURL'],
        description = json['description'],
        name = json['name'],
        primaryMuscles = json['primaryMuscles'].map((e) => Muscles.values[e]).toList().cast<Muscles>(),
        secondaryMuscles = json['secondaryMuscles'].map((e) => Muscles.values[e]).toList().cast<Muscles>(),
        id = null;

  ExerciseModel.fromFirebase(DocumentSnapshot doc)
      : id = doc.documentID,
        imageURL = doc.data['imageURL'],
        description = doc.data['description'],
        name = doc.data['name'],
        primaryMuscles = doc.data['primaryMuscles'].map((e) => Muscles.values[e]).toList().cast<Muscles>(),
        secondaryMuscles = doc.data['secondaryMuscles'].map((e) => Muscles.values[e]).toList().cast<Muscles>();

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['imageURL'] = this.imageURL;
    data['description'] = this.description;
    data['name'] = this.name;
    data['primaryMuscles'] = this.primaryMuscles.map((e) => e.index).toList();
    data['secondaryMuscles'] = this.secondaryMuscles.map((e) => e.index).toList();
    return data;
  }
}
