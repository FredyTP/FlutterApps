import 'package:GymStats/src/app_state.dart';
import 'package:GymStats/src/model/data/training_stats_data.dart';
import 'package:GymStats/src/model/training_model.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class TrainingStatsPage extends StatefulWidget {
  static const String route = "TrainingStatsPage";

  TrainingStatsPage({Key key}) : super(key: key);

  @override
  _TrainingStatsPageState createState() => _TrainingStatsPageState();
}

class _TrainingStatsPageState extends State<TrainingStatsPage> {
  @override
  Widget build(BuildContext context) {
    final bloc = AppStateContainer.of(context).blocProvider;
    return Container(
      child: StreamBuilder<List<TrainingModel>>(
        stream: bloc.trainingBloc.getTrainingsList(bloc.appUserBloc.currentUser.userData.id),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return LinearProgressIndicator();
          }
          final TrainingStatsData data = TrainingStatsData(trainingList: snapshot.data);
          return ListView(
            children: [
              Center(
                child: Container(
                  margin: EdgeInsets.all(10),
                  child: Table(
                    border: TableBorder.symmetric(inside: BorderSide()),
                    children: [
                      _buildTableRow("Sesiones", data.totalTrainings),
                      _buildTableRow("Peso Total", data.totalWeight, unit: "kg"),
                      _buildTableRow("Peso Máximo", data.maxWeight, unit: "kg"),
                      _buildTableRow("Peso Mínimo", data.minWeight, unit: "kg"),
                      _buildTableRow("Peso Medio por Serie", data.meanWeightPerSerie, unit: "kg"),
                      _buildTableRow("Repeticiones Totales", data.totalReps),
                      _buildTableRow("Repeticiones Máximas", data.maxReps),
                      _buildTableRow("Repeticiones Mínimas", data.minReps),
                    ],
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  TableRow _buildTableRow(String name, num value, {String unit}) {
    String vn;
    if (value.runtimeType == double) {
      vn = value.toStringAsFixed(2);
    } else {
      vn = value.toString();
    }
    if (unit != null) {
      vn += (" " + unit);
    }
    return TableRow(children: [
      Container(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
        alignment: Alignment.centerRight,
        child: AutoSizeText(
          name,
          maxLines: 1,
          style: TextStyle(fontSize: 20),
        ),
      ),
      Container(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: AutoSizeText(
          vn,
          maxLines: 1,
          style: TextStyle(fontSize: 20),
        ),
      )
    ]);
  }
}
