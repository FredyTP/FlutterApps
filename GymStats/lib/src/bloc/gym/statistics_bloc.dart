import 'package:GymStats/src/bloc/user/app_user_bloc.dart';
import 'package:GymStats/src/model/serie_model.dart';
import 'package:GymStats/src/model/training_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StatisticsBloc {
  AppUserBloc _userBloc;
  StatisticsBloc();
  void init(AppUserBloc userBloc) {
    _userBloc = userBloc;
  }

  Future<List<SerieModel>> getSeriesOfExercise(String exerciseID, {DateTime minTime}) async {
    final userID = _userBloc.currentUser.userData.id;
    final trainingCollection = _userBloc.getUserDocumentFromID(userID).collection("trainings").where("endTime", isGreaterThan: 0);
    QuerySnapshot docs;
    if (minTime != null) {
      docs = await trainingCollection.where("startTime", isGreaterThan: minTime.millisecondsSinceEpoch).get();
    } else {
      docs = await trainingCollection.get();
    }
    final series = <SerieModel>[];
    final list = docs.docs.map((e) => TrainingModel.fromFirebase(e)).toList();
    list.forEach((element) {
      element.series.forEach((element2) {
        if (element2.exerciseID == exerciseID) series.add(element2);
      });
    });
    return series;
    //.map((event) => event.documents.map((e) => TrainingModel.fromFirebase(e)).where((element) => element.endTime != null).toList());
  }
}
