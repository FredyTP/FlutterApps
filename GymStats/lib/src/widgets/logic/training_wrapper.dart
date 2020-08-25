import 'package:GymStats/src/bloc/gym/training_bloc.dart';
import 'package:flutter/material.dart';

//this widget displays the child if the user is currently training

class TrainingStreamWrapper extends StatelessWidget {
  final TrainingBloc trainingBloc;
  final Widget childTraining;
  final Widget childNotTraining;
  const TrainingStreamWrapper({Key key, @required this.trainingBloc, @required this.childNotTraining, @required this.childTraining}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<TrainingEvent>(
      stream: trainingBloc.trainingStream,
      builder: (context, snapshot) {
        if (trainingBloc.isTraining) {
          return childTraining;
        } else {
          return childNotTraining;
        }
      },
    );
  }
}
