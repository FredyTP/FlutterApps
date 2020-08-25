import 'dart:async';

import 'package:GymStats/src/bloc/user/app_user_bloc.dart';
import 'package:GymStats/src/bloc/gym/exercise_bloc.dart';
import 'package:GymStats/src/model/exercise_model.dart';
import 'package:GymStats/src/model/serie_model.dart';
import 'package:GymStats/src/model/training_model.dart';
import 'package:GymStats/src/model/workout_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//This class implements the logic of the training sessions
//keeps track of the current exercise beeing done, starts and stop the sesions and stores
//the traning results ( reps and kg's ) in firebase
class TrainingEvent {
  final ExerciseModel currentExercise;
  final TrainingModel currentTraining;
  final WorkoutModel workoutModel;
  final int activeExerciseIdx;
  final bool isTraining;
  final TrainingEventType eventType;

  TrainingEvent({
    this.currentExercise,
    this.currentTraining,
    this.workoutModel,
    this.isTraining,
    this.eventType,
    this.activeExerciseIdx,
  });
}

enum TrainingEventType {
  StartTraining,
  EndTraining,
  AddSerie,
  RemoveSerie,
  NotEnoughTime,
  NextExercise,
  LastExercise,
  AlreadyTraining,
}

class TrainingBloc {
  WorkoutModel _activeWorkout;
  ExerciseModel _activeExercise;
  TrainingModel _activeTraining;

  TrainingEvent lastEvent = TrainingEvent(isTraining: false);

  int _activeExerciseIdx = 0;
  bool _isTraining = false;

  ExerciseBloc _exerciseBloc;
  AppUserBloc _userBloc;

  StreamController<TrainingEvent> _exerciseStreamController = StreamController.broadcast();

  int _exerciseReps = 1;
  double _exerciseWeight = 0;

  int get exerciseReps => _exerciseReps;
  double get exerciseWeight => _exerciseWeight;

  void addReps(int reps) {
    _exerciseReps += reps;
    if (reps > 1) reps = 1;
  }

  void addWeight(num weight) {
    _exerciseWeight += weight;
    if (_exerciseWeight < 0) _exerciseWeight = 0;
  }

  Stream<TrainingEvent> get trainingStream => _exerciseStreamController.stream;

  void updateStream(TrainingEventType eventType) {
    lastEvent = TrainingEvent(
      currentExercise: _activeExercise,
      currentTraining: _activeTraining,
      workoutModel: _activeWorkout,
      isTraining: isTraining,
      eventType: eventType,
      activeExerciseIdx: _activeExerciseIdx,
    );
    _exerciseStreamController.add(lastEvent);
  }

  void init(ExerciseBloc exerciseBloc, AppUserBloc userBloc) {
    _exerciseBloc = exerciseBloc;
    _userBloc = userBloc;
  }

  void dispose() {
    _exerciseStreamController.close();

    this.endTraining();
  }

  bool get isTraining => _isTraining;

  bool get isFirstExercise => _activeExerciseIdx == 0;
  bool get isLastExercise => _activeExerciseIdx == _activeWorkout.exerciseIDList.length - 1;

  void resumeTraining() {
    if (isTraining) updateStream(TrainingEventType.AlreadyTraining);
  }

  Future startTraining(WorkoutModel workout) async {
    if (isTraining) {
      print("Already training");
      updateStream(TrainingEventType.AlreadyTraining);
      return;
    }

    _activeWorkout = workout;
    _activeExerciseIdx = 0;
    //Obtiene el primer ejercicio del workout
    _activeExercise = await _exerciseBloc.getExercise(_activeWorkout.exerciseIDList[_activeExerciseIdx]);

    //Crea una nueva sesión de entrenamiento(TrainingModel)
    final userID = _userBloc.currentUser.userData.id;
    final result = await Firestore.instance.collection("users").document(userID).collection("trainings").add(TrainingModel(startTime: DateTime.now()).toJson());

    if (result == null) {
      print("Error creating new training");
      return;
    }

    _activeTraining = TrainingModel.fromFirebase(await result.get());

    _isTraining = true;

    //Notifica el estado por el stream
    updateStream(TrainingEventType.StartTraining);

    return;
  }

  DocumentReference getTrainingReference(String id) {
    if (!isTraining) {
      return null;
    }
    final userID = _userBloc.currentUser.userData.id;
    return Firestore.instance.collection("users").document(userID).collection("trainings").document(id);
  }

  DocumentReference getActiveTrainingReference() {
    if (!isTraining) {
      return null;
    }
    return getTrainingReference(_activeTraining.id);
  }

  Future addSerie(SerieModel serie) async {
    print("Add serie");
    if (!isTraining) {
      print("IsNotTraining");
      return;
    }
    print("Is training");
    final lastTime = _activeTraining.series.length > 0 ? _activeTraining.series.last.timestamp : DateTime.fromMicrosecondsSinceEpoch(0);
    print("Got last Time");
    if (DateTime.now().difference(lastTime).inSeconds < 3) {
      print("NotEnoughTime");
      updateStream(TrainingEventType.NotEnoughTime);
      return;
    }
    print("EnoughTime");
    final training = getActiveTrainingReference();
    await training.updateData({
      "series": FieldValue.arrayUnion([serie.toJson()])
    });
    _activeTraining = TrainingModel.fromFirebase(await getActiveTrainingReference().get());

    updateStream(TrainingEventType.AddSerie);
  }

  Future deleteSerie(SerieModel serieModel) async {
    final training = getActiveTrainingReference();
    await training.updateData({
      "series": FieldValue.arrayRemove([serieModel.toJson()])
    });

    _activeTraining = TrainingModel.fromFirebase(await getActiveTrainingReference().get());

    updateStream(TrainingEventType.RemoveSerie);
  }

  Future goNextExercise() async {
    if (!isTraining) {
      return;
    }
    if (this.isLastExercise == false) {
      _activeExerciseIdx++;
      _activeExercise = await _exerciseBloc.getExercise(_activeWorkout.exerciseIDList[_activeExerciseIdx]);
      updateStream(TrainingEventType.NextExercise);
    } else {
      print("Already last Exercise");
    }
  }

  Future goLastExercise() async {
    if (!isTraining) {
      return;
    }
    if (_activeExerciseIdx > 0) {
      _activeExerciseIdx--;
      _activeExercise = await _exerciseBloc.getExercise(_activeWorkout.exerciseIDList[_activeExerciseIdx]);
      updateStream(TrainingEventType.LastExercise);
    } else {
      print("Already first Exercise");
    }
  }

  Future endTraining() async {
    if (isTraining) {
      if (_activeTraining.series.length == 0) {
        await getActiveTrainingReference().delete();
      } else {
        await getActiveTrainingReference().updateData({"endTime": DateTime.now().millisecondsSinceEpoch});
      }
      //Clean all data
      _activeExercise = null;
      _activeTraining = null;
      _activeExerciseIdx = 0;
      _activeWorkout = null;
      _isTraining = false;
      lastEvent = null;
      updateStream(TrainingEventType.EndTraining);
    }
  }

  Stream<List<TrainingModel>> getTrainingsList(userID) {
    return _userBloc
        .getUserDocumentFromID(userID)
        .collection("trainings") //,
        .snapshots()
        .asBroadcastStream()
        .map((event) => event.documents.map((e) => TrainingModel.fromFirebase(e)).where((element) => element.endTime != null).toList());
  }
}
