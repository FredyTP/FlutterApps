import 'package:GymStats/src/bloc/gym/statistics_bloc.dart';
import 'package:GymStats/src/bloc/storage_bloc.dart';
import 'package:GymStats/src/bloc/user/app_user_bloc.dart';
import 'package:GymStats/src/bloc/gym/exercise_bloc.dart';
import 'package:GymStats/src/bloc/gym/training_bloc.dart';
import 'package:GymStats/src/bloc/gym/workout_bloc.dart';

class BlocProvider {
  ExerciseBloc exerciseBloc;
  AppUserBloc appUserBloc;
  WorkoutBloc workoutBloc;
  TrainingBloc trainingBloc;
  StatisticsBloc statisticsBloc;
  StorageBloc storageBloc;
  void init() {
    storageBloc = StorageBloc();

    exerciseBloc = ExerciseBloc();

    appUserBloc = AppUserBloc();

    workoutBloc = WorkoutBloc(appUserBloc: appUserBloc, exerciseBloc: exerciseBloc);

    trainingBloc = TrainingBloc();

    statisticsBloc = StatisticsBloc();

    appUserBloc.init();

    trainingBloc.init(exerciseBloc, appUserBloc);

    statisticsBloc.init(appUserBloc);

    exerciseBloc.init(storageBloc);
  }

  void dispose() {
    trainingBloc.dispose();
  }
}
