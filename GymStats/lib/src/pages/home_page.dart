import 'package:GymStats/src/app_state.dart';
import 'package:GymStats/src/model/exercise_model.dart';
import 'package:GymStats/src/model/muscle_enum.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("HomePage")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final bloc = AppStateContainer.of(context).blocProvider.exerciseBloc;
          bloc.addExersice(ExerciseModel(
            description: "Recostado sobre un banco horizontal, los brazos estirados verticalmente, con la barra cargada en las manos, el movimiento consiste en bajar la barra hasta que toque el torso (fase excéntrica) y luego subir (fase concéntrica) hasta la posición inicial 1​. Las manos están en pronación, es decir, las palmas hacia los pies (la amplitud del movimiento debe adaptarse según la morfología). ",
            imageURL: "https://cambiandoeljuego.com/wp-content/uploads/2018/09/press-banca.jpg",
            primaryMuscles: [Muscles.pectoral],
            secondaryMuscles: [Muscles.triceps],
            name: "Press Banca con Barra",
          ));
        },
      ),
      body: Center(
        child: Text("Hello"),
      ),
    );
  }
}
