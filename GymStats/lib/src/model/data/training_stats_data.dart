import 'package:GymStats/src/model/training_model.dart';

class TrainingStatsData {
  //Stats data
//
//

  int get totalReps {
    int reps = 0;
    trainingList.forEach((element) {
      element.series.forEach((serie) {
        reps += serie.reps;
      });
    });
    return reps;
  }

  int get maxReps {
    int reps = 1;
    trainingList.forEach((element) {
      element.series.forEach((serie) {
        if (reps < serie.reps) reps = serie.reps;
      });
    });
    return reps;
  }

  int get minReps {
    int reps = 999999;
    trainingList.forEach((element) {
      element.series.forEach((serie) {
        if (reps > serie.reps) reps = serie.reps;
      });
    });
    return reps;
  }

  num get totalWeight {
    num peso = 0;
    trainingList.forEach((element) {
      element.series.forEach((serie) {
        peso += serie.weight;
      });
    });
    return peso;
  }

  num get maxWeight {
    num maxpeso = 0;
    trainingList.forEach((element) {
      element.series.forEach((serie) {
        if (maxpeso < serie.weight) maxpeso = serie.weight;
      });
    });
    return maxpeso;
  }

  num get minWeight {
    num minpeso = double.infinity;
    trainingList.forEach((element) {
      element.series.forEach((serie) {
        if (minpeso > serie.weight) minpeso = serie.weight;
      });
    });
    return minpeso;
  }

  num get meanWeightPerSerie {
    return totalWeight / totalSeries;
  }

  int get totalTrainings {
    return trainingList.length;
  }

  int get totalSeries {
    int series = 0;
    trainingList.forEach((element) {
      series += element.series.length;
    });
    return series;
  }

  final List<TrainingModel> trainingList;
  TrainingStatsData({this.trainingList});
}
