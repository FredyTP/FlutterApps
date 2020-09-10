import 'package:GymStats/src/model/serie_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TrainingModel {
  final DateTime startTime;
  final DateTime endTime;

  final String id;

  final List<SerieModel> series;

  final String workoutID;

  TrainingModel({this.workoutID, this.endTime, this.id, this.series = const <SerieModel>[], this.startTime});

  TrainingModel.fromFirebase(DocumentSnapshot doc)
      : this.startTime = doc.data()["startTime"] != null ? DateTime.fromMillisecondsSinceEpoch(doc.data()["startTime"]) : null,
        this.endTime = doc.data()["endTime"] != null ? DateTime.fromMillisecondsSinceEpoch(doc.data()["endTime"]) : null,
        this.id = doc.id,
        this.series = doc.data()["series"].map((e) => SerieModel.fromJson(e)).toList().cast<SerieModel>(),
        this.workoutID = doc.data()["workoutID"];

  Map<String, dynamic> toJson() {
    return {
      "startTime": this.startTime?.millisecondsSinceEpoch,
      "endTime": this.endTime?.millisecondsSinceEpoch,
      "series": this.series.map((e) => e.toJson()).toList(),
      "workoutID": this.workoutID,
    };
  }
}
