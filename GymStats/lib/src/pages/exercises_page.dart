import 'package:GymStats/src/app_state.dart';
import 'package:GymStats/src/model/exercise_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ExercisesPage extends StatelessWidget {
  const ExercisesPage({Key key}) : super(key: key);

  static const route = "ExercisesPage";

  @override
  Widget build(BuildContext context) {
    final bloc = AppStateContainer.of(context).blocProvider;
    return Scaffold(
      appBar: AppBar(title: Text("Ejercicios")),
      body: Container(
        child: StreamBuilder(
          stream: bloc.exerciseBloc.getExercisesStream(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              final exerciseList = snapshot.data;
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                itemCount: exerciseList.documents.length,
                itemBuilder: (context, index) {
                  final exercise = ExerciseModel.fromJson(exerciseList.documents[index].data);
                  print("id:");
                  print(exerciseList.documents[index].documentID);
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
        child: Image.network(
          exercise.imageURL,
          fit: BoxFit.fitWidth,
          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes : null,
              ),
            );
          },
        ),
        footer: Container(width: double.infinity, color: Colors.amber, alignment: Alignment.center, padding: EdgeInsets.all(12), child: Text(exercise.name)),
      ),
    );
  }
}
