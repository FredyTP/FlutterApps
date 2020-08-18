import 'package:GymStats/src/model/muscle_enum.dart';

class ExerciseModel {
  String imageURL;
  String description;
  String name;
  List<Muscles> primaryMuscles;
  List<Muscles> secondaryMuscles;

  ExerciseModel({this.imageURL, this.description, this.name, this.primaryMuscles, this.secondaryMuscles});

  ExerciseModel.fromJson(Map<String, dynamic> json) {
    imageURL = json['imageURL'];
    description = json['description'];
    name = json['name'];
    primaryMuscles = json['primaryMuscles'].map((e) => Muscles.values[e]).toList().cast<Muscles>();
    secondaryMuscles = json['secondaryMuscles'].map((e) => Muscles.values[e]).toList().cast<Muscles>();
  }

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
