import 'package:GymStats/src/app_state.dart';
import 'package:GymStats/src/model/training_model.dart';
import 'package:flutter/material.dart';

class TrainingsListPage extends StatelessWidget {
  static const String route = "TrainingsListPage";
  const TrainingsListPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = AppStateContainer.of(context).blocProvider;
    return Scaffold(
      appBar: AppBar(
        title: Text("Entrenamientos"),
      ),
      body: Container(
        child: StreamBuilder<List<TrainingModel>>(
          stream: bloc.trainingBloc.getTrainingsList(bloc.appUserBloc.currentUser.userData.id),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  final training = snapshot.data[index];
                  final duration = training.endTime.difference(training.startTime);
                  return ListTile(
                    title: Text("Duracion: " + duration.inMinutes.toString() + "'"),
                  );
                },
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
