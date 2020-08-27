import 'package:GymStats/src/app_state.dart';
import 'package:GymStats/src/model/workout_model.dart';
import 'package:GymStats/src/pages/exercises/exercises_page.dart';
import 'package:GymStats/src/pages/stats/graphics_page.dart';
import 'package:GymStats/src/pages/training/training_page.dart';
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
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: Text("HomePage"),
        actions: [
          FlatButton.icon(
              onPressed: () => bloc.appUserBloc.signOut(),
              icon: Icon(
                Icons.exit_to_app,
                color: Colors.white,
              ),
              label: Text(
                "Cerrar Sesión",
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
      body: Center(
        child: GridView(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          children: [
            TrainingStreamWrapper(
              trainingBloc: bloc.trainingBloc,
              childNotTraining: buildMenuCard(
                context,
                "Empezar Entrenamiento",
                imgpath: "assets/menu/undraw_healthy_habit.png",
                function: () => Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return WorkoutListPage(onSelect: (BuildContext context, WorkoutModel wk) async => WorkoutListPage.startTraining(context, wk));
                    },
                  ),
                ),
              ),
              childTraining: buildMenuCard(context, "Volver al Entrenamiento", imgpath: "assets/menu/undraw_healthy_habit.png", route: TrainingPage.route),
            ),
            buildMenuCard(context, "Ejercicios", imgpath: "assets/menu/undraw_personal_trainer.png", route: ExercisesPage.route),
            buildMenuCard(context, "Plantillas",
                imgpath: "assets/menu/undraw_portfolio.png",
                function: () => Navigator.of(context).push(PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return WorkoutListPage(onSelect: (BuildContext context, WorkoutModel wk) async => WorkoutListPage.openInfo(context, wk));
                      },
                    ))),
            buildMenuCard(context, "Crear Plantilla", imgpath: "assets/menu/undraw_add_notes.png", route: CreateWorkoutPage.route),
            buildMenuCard(context, "Perfil", imgpath: "assets/menu/undraw_fitness_stats.png", route: GraphicsPage.route),
          ],
        ),
      ),
    );
  }

  GestureDetector buildMenuCard(BuildContext context, String name, {Function function, String route, String imgpath}) {
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
              child: imgpath == null ? Container() : Image.asset(imgpath),
            ),
            footer: GridTileBar(
              backgroundColor: Color.fromRGBO(30, 30, 30, 1),
              title: Center(child: Text(name)),
            ),
          )),
    );
  }
}
