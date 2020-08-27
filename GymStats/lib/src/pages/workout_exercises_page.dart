import 'package:GymStats/src/model/exercise_model.dart';
import 'package:GymStats/src/widgets/logic/exercise_image.dart';
import 'package:flutter/material.dart';

import '../app_state.dart';

class WorkoutExercisesPage extends StatefulWidget {
  final String workoutID;
  WorkoutExercisesPage({Key key, this.workoutID}) : super(key: key);

  @override
  _WorkoutExercisesPageState createState() => _WorkoutExercisesPageState();
}

class _WorkoutExercisesPageState extends State<WorkoutExercisesPage> {
  @override
  Widget build(BuildContext context) {
    final bloc = AppStateContainer.of(context).blocProvider;
    return Scaffold(
      appBar: AppBar(title: Text("Workout Exercises")),
      body: Container(
        child: StreamBuilder(
          stream: bloc.workoutBloc.getWorkoutExercises(id: widget.workoutID),
          builder: (context, AsyncSnapshot<List<ExerciseModel>> snapshot) {
            if (snapshot.hasData) {
              final exerciseList = snapshot.data;

              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                itemCount: exerciseList.length,
                itemBuilder: (context, index) {
                  final exercise = exerciseList[index];
                  print("id:");

                  return buildExerciseCard(exercise);
                },
              );
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }

  Card buildExerciseCard(ExerciseModel exercise) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 7,
      color: Color.fromRGBO(250, 190, 120, 1),
      child: GridTile(
        child: ExerciseImage(
          imgPath: exercise.imagePath,
        ),
        footer: Container(width: double.infinity, color: Colors.amber, alignment: Alignment.center, padding: EdgeInsets.all(12), child: Text(exercise.name)),
      ),
    );
  }
}
