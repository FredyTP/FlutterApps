import 'package:GymStats/src/bloc/gym/exercise_bloc.dart';
import 'package:GymStats/src/bloc/user/app_user_bloc.dart';
import 'package:GymStats/src/model/exercise_model.dart';
import 'package:GymStats/src/model/workout_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WorkoutBloc {
  final AppUserBloc appUserBloc;
  final ExerciseBloc exerciseBloc;
  WorkoutBloc({this.appUserBloc, this.exerciseBloc});

  Future addWorkout({String uid, WorkoutModel workout}) {
    return appUserBloc.getUserDocumentFromID(uid).collection("workouts").add(workout.toJson());
  }

  Stream<QuerySnapshot> getUserWorkouts({String uid}) {
    return appUserBloc.getUserDocumentFromID(uid).collection("workouts").snapshots().asBroadcastStream();
  }

  Stream<List<ExerciseModel>> getWorkoutExercises({String id}) {
    final userid = appUserBloc.currentUser.userData.id;
    return appUserBloc
        .getUserDocumentFromID(userid)
        .collection("workouts")
        .document(id) //,
        .snapshots()
        .asBroadcastStream()
        .asyncMap((event) async {
      final workout = WorkoutModel.fromFirebase(event);
      final list = List<ExerciseModel>();
      for (final id in workout.exerciseIDList) {
        list.add(await exerciseBloc.getExercise(id));
      }
      return list;
    });
  }
}
