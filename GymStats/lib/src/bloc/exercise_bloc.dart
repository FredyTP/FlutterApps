import 'package:GymStats/src/model/exercise_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ExerciseBloc {
  final _collection = Firestore.instance.collection("exercises");

  Stream<QuerySnapshot> getExercisesStream() {
    return _collection.snapshots().asBroadcastStream();
  }

  Future addExersice(ExerciseModel exercise) async {
    return await _collection.add(exercise.toJson());
  }
}
