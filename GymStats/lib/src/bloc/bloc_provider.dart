import 'package:GymStats/src/bloc/exercise_bloc.dart';

class BlocProvider {
  ExerciseBloc exerciseBloc;
  void init() {
    exerciseBloc = ExerciseBloc();
  }
}
