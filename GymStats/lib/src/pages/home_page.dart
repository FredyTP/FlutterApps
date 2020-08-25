import 'package:GymStats/src/app_state.dart';
import 'package:GymStats/src/model/workout_model.dart';
import 'package:GymStats/src/pages/exercises_page.dart';
import 'package:GymStats/src/pages/training/training_page.dart';
import 'package:GymStats/src/pages/trainings_list_page.dart';
import 'package:GymStats/src/pages/workout_template_list_page.dart';
import 'package:GymStats/src/widgets/logic/training_wrapper.dart';
import 'package:flutter/material.dart';

import 'create_workout_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);
  static const route = "HomePage";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final bloc = AppStateContainer.of(context).blocProvider;
    return Scaffold(
      appBar: AppBar(title: Text("HomePage")),
      body: Center(
        child: GridView(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          children: [
            TrainingStreamWrapper(
              trainingBloc: bloc.trainingBloc,
              childNotTraining: buildMenuCard(
                context,
                "Empezar Entrenamiento",
                function: () => Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return WorkoutListPage(onSelect: (BuildContext context, WorkoutModel wk) async => WorkoutListPage.startTraining(context, wk));
                    },
                  ),
                ),
              ),
              childTraining: buildMenuCard(context, "Volver al Entrenamiento", route: TrainingPage.route),
            ),
            buildMenuCard(context, "Ejercicios", route: ExercisesPage.route),
            buildMenuCard(context, "Plantillas",
                function: () => Navigator.of(context).push(PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return WorkoutListPage(onSelect: (BuildContext context, WorkoutModel wk) async => WorkoutListPage.openInfo(context, wk));
                      },
                    ))),
            buildMenuCard(context, "Crear Plantilla", route: CreateWorkoutPage.route),
            buildMenuCard(context, "Entrenamientos", route: TrainingsListPage.route),
          ],
        ),
      ),
    );
  }

  GestureDetector buildMenuCard(BuildContext context, String name, {Function function, String route}) {
    return GestureDetector(
      onTap: () {
        function?.call();
        if (route != null) Navigator.of(context).pushNamed(route);
      },
      child: Card(
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: GridTile(
            child: Container(
              color: Colors.red,
            ),
            footer: GridTileBar(
              backgroundColor: Color.fromRGBO(30, 30, 30, 1),
              title: Center(child: Text(name)),
            ),
          )),
    );
  }
}
