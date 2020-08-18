import 'package:GymStats/src/app_state.dart';
import 'package:GymStats/src/model/exercise_model.dart';
import 'package:GymStats/src/model/muscle_enum.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ExercisesPage extends StatelessWidget {
  const ExercisesPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = AppStateContainer.of(context).blocProvider;
    return Scaffold(
      appBar: AppBar(title: Text("HomePage")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final bloc = AppStateContainer.of(context).blocProvider.exerciseBloc;
          bloc.addExersice(ExerciseModel(
            description: "",
            imageURL: "https://rincondelmusculo.com/wp-content/uploads/2016/02/user_2801_cruce_poleas_bajas.jpg",
            primaryMuscles: [Muscles.pectoral],
            secondaryMuscles: [],
            name: "Crossover Bajo",
          ));
        },
      ),
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
                  return Card(
                    clipBehavior: Clip.antiAlias,
                    elevation: 7,
                    color: Color.fromRGBO(250, 190, 120, 1),
                    child: GridTile(
                      child: Image.network(
                        exercise.imageURL,
                        fit: BoxFit.fitWidth,
                      ),
                      footer: Container(width: double.infinity, color: Colors.amber, alignment: Alignment.center, padding: EdgeInsets.all(12), child: Text(exercise.name)),
                    ),
                  );
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
}
