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
        .doc(id) //,
        .snapshots()
        .asBroadcastStream()
        .asyncMap((event) async {
      final workout = WorkoutModel.fromFirebase(event);
      final list = List<ExerciseModel>();
      for (final eid in workout.exerciseIDList) {
        final exercise = await exerciseBloc.getExercise(eid);
        if (exercise == null) {
          //Delete exercise if it doesnt exist ^.^
          await appUserBloc.getUserDocumentFromID(userid).collection("workouts").doc(id).update({
            "exerciseIDList": FieldValue.arrayRemove([eid])
          });
        } else {
          //Otherwise add to exercise list to return :D
          list.add(exercise);
        }
      }
      return list;
    });
  }
}
