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
        child: Column(
          children: [
            Container(
              child: Hero(
                child: exerciseImg,
                tag: exerciseModel.id,
                transitionOnUserGestures: true,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Divider(),
            Center(
              child: Text(
                "¿Como realizarlo?",
                style: TextStyle(fontSize: 25),
              ),
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: Text(exerciseModel.description),
            )
          ],
        ),
      ),
    );
  }
}
