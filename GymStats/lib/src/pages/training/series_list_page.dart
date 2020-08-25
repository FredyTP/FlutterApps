import 'package:GymStats/src/app_state.dart';
import 'package:GymStats/src/bloc/gym/exercise_bloc.dart';
import 'package:GymStats/src/model/exercise_model.dart';
import 'package:GymStats/src/model/serie_model.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:GymStats/src/bloc/gym/training_bloc.dart';
import 'package:flutter/material.dart';

class SeriesListPage extends StatelessWidget {
  final TrainingEvent trainingEvent;
  const SeriesListPage({Key key, @required this.trainingEvent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = AppStateContainer.of(context).blocProvider;
    final exerciseBloc = bloc.exerciseBloc;
    final series = trainingEvent.currentTraining.series;
    return Container(
      color: Colors.white,
      child: ListView.builder(
        itemCount: series.length,
        itemBuilder: (context, index) {
          final serie = series[index];
          return GestureDetector(
              onLongPress: () async {
                final delete = await _showDeleteSeriePopup(context, exerciseBloc, serie);
                if (delete ?? false) await bloc.trainingBloc.deleteSerie(serie);
              },
              child: _createSerieItem(exerciseBloc, serie));
        },
      ),
    );
  }

  Widget _createSerieItem(ExerciseBloc exerciseBloc, SerieModel serieModel) {
    final String exerciseID = serieModel.exerciseID;
    final String reps = serieModel.reps.toString();
    final String weight = serieModel.weight.toString();
    final String hour = serieModel.timestamp.hour.toString() + ":" + (serieModel.timestamp.minute < 10 ? ("0" + serieModel.timestamp.minute.toString()) : serieModel.timestamp.minute.toString());

    return Container(
      //color: Colors.blue,
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(blurRadius: 7, spreadRadius: 1, color: Colors.black45)],
        border: Border.all(color: Colors.grey),
        color: Color.fromRGBO(230, 230, 230, 1),
        borderRadius: BorderRadius.circular(10),
      ),
      height: 88,
      padding: EdgeInsets.all(6),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: FutureBuilder<ExerciseModel>(
                future: exerciseBloc.getExercise(exerciseID),
                builder: (context, snapshot) {
                  return AutoSizeText(
                    snapshot.data?.name ?? "Cargando...",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 23, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
                  );
                }),
          ),
          Expanded(
            flex: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _createInfoItem(top: reps, bot: "Reps"),
                _createInfoItem(top: weight + " kg", bot: "Peso"),
                _createInfoItem(top: hour, bot: "Hora"),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _createInfoItem({String top, @required String bot, Widget topWidget}) {
    return Expanded(
      flex: 1,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 7),
        //color: Colors.red,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            top != null
                ? AutoSizeText(
                    top,
                    maxLines: 1,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  )
                : topWidget,
            SizedBox(
              height: 7,
            ),
            AutoSizeText(
              bot,
              textAlign: TextAlign.center,
              maxLines: 1,
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _showDeleteSeriePopup(BuildContext context, ExerciseBloc bloc, SerieModel serieModel) async {
    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Eliminar serie"),
          actions: [
            FlatButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text("Cancelar"),
            ),
            RaisedButton(
              color: Colors.red,
              onPressed: () => Navigator.of(context).pop(true),
              child: Text("Eliminar"),
            ),
          ],
          content: Container(width: MediaQuery.of(context).size.width, child: _createSerieItem(bloc, serieModel)),
        );
      },
    );
  }
}
