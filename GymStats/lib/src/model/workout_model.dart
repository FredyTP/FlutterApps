import 'package:GymStats/src/model/exercise_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WorkoutModel {
  final List<String> exerciseIDList;
  final String name;
  final String id;
  WorkoutModel({this.exerciseIDList, this.name, this.id});

  WorkoutModel.fromFirebase(DocumentSnapshot doc)
      : this.exerciseIDList = doc.data["exerciseIDList"]?.cast<String>(),
        this.name = doc.data["name"],
        this.id = doc.documentID;

  Map<String, dynamic> toJson() {
    return {
      "exerciseIDList": this.exerciseIDList,
      "name": this.name,
    };
  }
}
