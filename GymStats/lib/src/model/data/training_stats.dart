import 'package:GymStats/src/model/data/statistics.dart';

import '../training_model.dart';

class TrainingStats {
  //Duration of the training
  static Duration duration(TrainingModel trainingModel) {
    return trainingModel.endTime.difference(trainingModel.startTime);
  }

  //Number of series
  static int numSeries(TrainingModel trainingModel) {
    return trainingModel.series.length;
  }

  //------------REPS------------------//

  //Maximum number of repetitions in the training
  static int maxReps(TrainingModel trainingModel) {
    return Statistics.max(_repsList(trainingModel));
  }

  //Mínimum number of repetitions in the training
  static int minReps(TrainingModel trainingModel) {
    return Statistics.min(_repsList(trainingModel));
  }

  static List<num> _repsList(TrainingModel trainingModel) {
    return trainingModel.series.map((e) => e.reps).toList();
  }

  //------------WEIGHT----------------//

  //Maximo peso levantado en el entrenamiento
  static num maxWeight(TrainingModel trainingModel) {
    return Statistics.max(_weightList(trainingModel));
  }

  //Mínimo peso levantado en el entrenamiento
  static num minWeight(TrainingModel trainingModel) {
    return Statistics.min(_weightList(trainingModel));
  }

  static List<num> _weightList(TrainingModel trainingModel) {
    return trainingModel.series.map((e) => e.weight).toList();
  }

  //------------FORMAT---------------//

  static String getDurationString(TrainingModel trainingModel, {bool hour = true, bool min = true, bool sec = false}) {
    String formated = "";
    final duration = TrainingStats.duration(trainingModel);
    if (hour) {
      print(duration.inHours);
      if (duration.inHours > 0) {
        formated += duration.inHours.toString();
        formated += " h";
      }
    }
    if (min) {
      final minutes = duration.inMinutes - duration.inHours * 60;
      print(minutes);
      if (minutes > 0) {
        formated += minutes.toString();
        formated += " min";
      } else {
        if (!sec) {
          formated += "0 min";
        }
      }
    }
    if (sec) {
      final secs = duration.inSeconds - (duration.inMinutes - duration.inHours * 60) * 60;
      if (secs > 0) {
        formated += secs.toString();
        formated += " ''";
      }
    }

    return formated;
  }
}
