import 'package:GymStats/src/bloc/user/app_user_bloc.dart';
import 'package:GymStats/src/bloc/gym/exercise_bloc.dart';
import 'package:GymStats/src/bloc/gym/training_bloc.dart';
import 'package:GymStats/src/bloc/gym/workout_bloc.dart';

class BlocProvider {
  ExerciseBloc exerciseBloc;
  AppUserBloc appUserBloc;
  WorkoutBloc workoutBloc;
  TrainingBloc trainingBloc;
  void init() {
    exerciseBloc = ExerciseBloc();

    appUserBloc = AppUserBloc();

    appUserBloc.init();

    workoutBloc = WorkoutBloc(appUserBloc: appUserBloc, exerciseBloc: exerciseBloc);

    trainingBloc = TrainingBloc();

    trainingBloc.init(exerciseBloc, appUserBloc);
  }

  void dispose() {
    trainingBloc.dispose();
  }
}
