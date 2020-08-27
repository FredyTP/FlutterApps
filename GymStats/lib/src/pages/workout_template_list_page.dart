import 'package:GymStats/src/model/workout_model.dart';
import 'package:GymStats/src/pages/workout_exercises_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../app_state.dart';
import 'training/training_page.dart';

class WorkoutListPage extends StatefulWidget {
  static const route = "WorkoutListPage";
  final Function(BuildContext, WorkoutModel) onSelect;

  WorkoutListPage({Key key, this.onSelect}) : super(key: key);

  @override
  _WorkoutListState createState() => _WorkoutListState();

  static Future openInfo(BuildContext context, WorkoutModel wk) async {
    await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => WorkoutExercisesPage(
              workoutID: wk.id,
            )));
  }

  static Future startTraining(BuildContext context, WorkoutModel wk) async {
    final result = await _showStartWorkoutPopup(context, wk);
    if (result ?? false) {
      final bloc = AppStateContainer.of(context).blocProvider;
      print(bloc.trainingBloc.isTraining);
      bloc.trainingBloc.startTraining(wk);
      Navigator.of(context).pop();
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => TrainingPage()));
    }
  }

  static Future<bool> _showStartWorkoutPopup(BuildContext context, WorkoutModel wt) async {
    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Empezar sesión: ${wt.name}"),
          actions: [
            FlatButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text("Cancelar"),
            ),
            RaisedButton(
              color: Colors.green,
              onPressed: () => Navigator.of(context).pop(true),
              child: Text("Aceptar"),
            ),
          ],
        );
      },
    );
  }
}

class _WorkoutListState extends State<WorkoutListPage> {
  @override
  Widget build(BuildContext context) {
    final bloc = AppStateContainer.of(context).blocProvider;
    return Scaffold(
      appBar: AppBar(title: Text("Workout Templates List")),
      body: Container(
        child: StreamBuilder(
          stream: bloc.workoutBloc.getUserWorkouts(uid: bloc.appUserBloc.currentUser.userData.id),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              final workoutList = snapshot.data;
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                itemCount: workoutList.docs.length,
                itemBuilder: (context, index) {
                  final workout = WorkoutModel.fromFirebase(workoutList.docs[index]);

                  return buildWorkoutCard(context, workout);
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

  Widget buildWorkoutCard(BuildContext context, WorkoutModel workout) {
    return GestureDetector(
      onTap: () async {
        await widget.onSelect?.call(context, workout);
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 7,
        color: Color.fromRGBO(250, 190, 120, 1),
        child: GridTile(
          child: Container(
            color: Colors.blueGrey,
          ),
          footer: Container(
              width: double.infinity,
              color: Colors.amber,
              alignment: Alignment.center,
              padding: EdgeInsets.all(12),
              child: Text(
                workout.name,
              )),
        ),
      ),
    );
  }
}
