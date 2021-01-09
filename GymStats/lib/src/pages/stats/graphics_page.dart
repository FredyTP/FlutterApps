import 'package:GymStats/src/app_state.dart';
import 'package:GymStats/src/bloc/bloc_provider.dart';
import 'package:GymStats/src/model/exercise_model.dart';
import 'package:GymStats/src/model/serie_model.dart';
import 'package:GymStats/src/pages/exercises/exercises_page.dart';
import 'package:GymStats/src/widgets/charts/bar_chart.dart';
import 'package:flutter/material.dart';

import 'package:charts_flutter/flutter.dart' as charts;

class GraphicsPage extends StatefulWidget {
  static const String route = "GraphicsPage";

  GraphicsPage({Key key}) : super(key: key);

  @override
  _GraphicsPageState createState() => _GraphicsPageState();
}

class _GraphicsPageState extends State<GraphicsPage> {
  DateTime fromDate = getToday();
  DateTime customDate;
  String exerciseID;
  int selection = 0;
  @override
  Widget build(BuildContext context) {
    final bloc = AppStateContainer.of(context).blocProvider;
    return Container(
      child: Column(
        children: [createExerciseGraphic(bloc)],
      ),
    );
  }

  Widget createExerciseGraphic(BlocProvider bloc) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: 300,
          child: FutureBuilder<List<SerieModel>>(
            future: bloc.statisticsBloc.getSeriesOfExercise(exerciseID, minTime: fromDate),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final list = snapshot.data;
                list.sort((SerieModel a, SerieModel b) => a.timestamp.compareTo(b.timestamp));
                snapshot.data.forEach((element) {
                  print(element.reps.toString());
                });
                final seriesList = [
                  charts.Series<SerieModel, DateTime>(
                    id: 'Pesos',
                    colorFn: (SerieModel model, __) => charts.ColorUtil.fromDartColor(Colors.blue),
                    domainFn: (SerieModel model, index) => model.timestamp,
                    measureFn: (SerieModel model, _) {
                      if (selection == 0)
                        return model.weight;
                      else {
                        return model.reps;
                      }
                    },
                    data: list,
                  )
                ];
                return BarChart(seriesList, animate: true);
              } else {
                return LinearProgressIndicator();
              }
            },
          ),
        ),
        buildSelectVariable(),
        buildSelectExercise(context, bloc),
        buildSelectDate(),
      ],
    );
  }

  Row buildSelectDate() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text("Mostrar desde"),
        DropdownButton(
          onChanged: (value) {
            setState(() {
              fromDate = value;
              print((value as DateTime).millisecondsSinceEpoch > 1599778679452);
              print(DateTime.fromMillisecondsSinceEpoch(1599778679452));
            });
          },
          value: fromDate,
          items: [
            DropdownMenuItem(
              child: Text("Hoy"),
              value: getToday(),
            ),
            DropdownMenuItem(
              child: Text("Ayer"),
              value: getToday().subtract(Duration(days: 1)),
            ),
            DropdownMenuItem(
              child: Text("Ultimos 3 dias"),
              value: getToday().subtract(Duration(days: 3)),
            ),
            DropdownMenuItem(
              child: Text("Última Semana"),
              value: getToday().subtract(Duration(days: 7)),
            ),
            DropdownMenuItem(
              child: Text("Último Mes"),
              value: getToday().subtract(Duration(days: 31)),
            ),
            DropdownMenuItem(
              child: Text("Último Año"),
              value: getToday().subtract(Duration(days: 365)),
            ),
            DropdownMenuItem(
              child: Text("Todos"),
              value: DateTime.fromMillisecondsSinceEpoch(1),
            ),
          ],
        )
      ],
    );
  }

  static DateTime getToday() {
    final now = DateTime.now();

    final day = now.day;
    final month = now.month;
    final year = now.year;

    return DateTime(year, month, day);
  }

  void showPopupCalendar(BuildContext context) {
    showDialog(
        context: context,
        child: AlertDialog(
          content: Container(
            width: 400,
            height: 300,
            child: CalendarDatePicker(
              firstDate: DateTime.fromMillisecondsSinceEpoch(0),
              lastDate: DateTime.now(),
              initialDate: DateTime.now(),
              currentDate: fromDate,
              onDateChanged: (value) {
                setState(() {
                  customDate = value;
                });
              },
            ),
          ),
        ));
  }

  Row buildSelectExercise(BuildContext context, BlocProvider bloc) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          "Ejercicio: ",
          style: TextStyle(fontSize: 20),
        ),
        RaisedButton(
          child: Text("Seleccionar"),
          onPressed: () async {
            exerciseID = await Navigator.of(context).push(MaterialPageRoute(
              builder: (context) {
                return ExercisesPage(
                  canEdit: false,
                  onSelect: (BuildContext context, ExerciseModel model, Widget imgl) {
                    Navigator.of(context).pop(model.id);
                  },
                );
              },
            ));
            setState(() {});
          },
        ),
      ],
    );
  }

  Row buildSelectVariable() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          "Variable: ",
          style: TextStyle(fontSize: 20),
        ),
        DropdownButton(
          onChanged: (value) {
            setState(() {
              selection = value;
            });
          },
          value: selection,
          items: [
            DropdownMenuItem(
              child: Text(
                "Peso",
                style: TextStyle(fontSize: 20),
              ),
              value: 0,
            ),
            DropdownMenuItem(
              child: Text(
                "Reps",
                style: TextStyle(fontSize: 20),
              ),
              value: 1,
            ),
          ],
        ),
      ],
    );
  }

  // ignore: unused_element
  static String getDayFormat(DateTime dt, {bool year = true, bool month = true, bool hour = false, bool min = false}) {
    String formatted = "";
    if (hour) {
      String hour = dt.hour.toString();
      formatted += hour;
      if (min) {
        String min = dt.minute < 10 ? ("0" + dt.minute.toString()) : dt.minute.toString();
        formatted += ":";
        formatted += min;
        formatted += "\n";
      }
    }
    formatted += dt.day < 10 ? ("0" + dt.day.toString()) : dt.day.toString();
    formatted += "/";
    formatted += dt.month < 10 ? ("0" + dt.month.toString()) : dt.month.toString();

    if (year) {
      formatted += "/";
      formatted += dt.year.toString();
    }
    return formatted;
  }
}
