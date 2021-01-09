import 'package:GymStats/src/app_state.dart';
import 'package:GymStats/src/model/data/training_stats.dart';
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
        title: Text("Lista de Entrenamientos"),
      ),
      body: Container(
        child: StreamBuilder<List<TrainingModel>>(
          stream: bloc.statisticsBloc.getTrainingsListStream(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  final tm = snapshot.data[index];
                  print(TrainingStats.getDurationString(tm));
                  return ListTile(
                    leading: Text("${TrainingStats.numSeries(tm)}"),
                    trailing: Text("${TrainingStats.getDurationString(tm)}"),
                  );
                },
              );
            } else {
              return LinearProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
