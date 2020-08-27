import 'package:GymStats/src/model/exercise_model.dart';
import 'package:flutter/material.dart';

class ExerciseInfoPage extends StatelessWidget {
  final ExerciseModel exerciseModel;
  final Widget exerciseImg;
  const ExerciseInfoPage({Key key, this.exerciseModel, this.exerciseImg}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Hero(
            child: exerciseImg,
            tag: exerciseModel.id,
            transitionOnUserGestures: true,
          ),
        ),
      ),
    );
  }
}
