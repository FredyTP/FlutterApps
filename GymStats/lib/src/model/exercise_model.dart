import 'package:GymStats/src/enum/equipment_enum.dart';
import 'package:GymStats/src/enum/muscle_enum.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ExerciseModel {
  final String imagePath;
  final String description;
  final String name;
  final String id;
  final List<Muscles> primaryMuscles;
  final List<Muscles> secondaryMuscles;
  final List<Equipment> equipment;

  //final int difficultyLevel;

  ExerciseModel({this.imagePath, this.description, this.name, this.primaryMuscles, this.secondaryMuscles, this.equipment, this.id});

  ExerciseModel.fromJson(Map<String, dynamic> json)
      : imagePath = json['imagePath'],
        description = json['description'],
        name = json['name'],
        primaryMuscles = json['primaryMuscles'].map((e) => Muscles.values[e]).toList().cast<Muscles>(),
        secondaryMuscles = json['secondaryMuscles'].map((e) => Muscles.values[e]).toList().cast<Muscles>(),
        equipment = json['equipment']?.map((e) => Equipment.values[e])?.toList()?.cast<Equipment>(),
        id = null;

  ExerciseModel.fromFirebase(DocumentSnapshot doc)
      : id = doc.id,
        imagePath = doc.data()['imagePath'],
        description = doc.data()['description'],
        name = doc.data()['name'],
        primaryMuscles = doc.data()['primaryMuscles'].map((e) => Muscles.values[e]).toList().cast<Muscles>(),
        secondaryMuscles = doc.data()['secondaryMuscles'].map((e) => Muscles.values[e]).toList().cast<Muscles>(),
        equipment = doc.data()['equipment']?.map((e) => Equipment.values[e])?.toList()?.cast<Equipment>();

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['imagePath'] = this.imagePath;
    data['description'] = this.description;
    data['name'] = this.name;
    data['primaryMuscles'] = this.primaryMuscles.map((e) => e.index).toList();
    data['secondaryMuscles'] = this.secondaryMuscles.map((e) => e.index).toList();
    data['equipment'] = this.equipment?.map((e) => e.index)?.toList();
    return data;
  }
}
