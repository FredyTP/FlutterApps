import 'package:GymStats/src/app_state.dart';
import 'package:GymStats/src/bloc/gym/training_bloc.dart';
import 'package:GymStats/src/pages/training/series_list_page.dart';

import 'package:flutter/material.dart';

import 'add_serie_page.dart';

class TrainingPage extends StatefulWidget {
  static const String route = "TrainingPage";

  TrainingPage({Key key}) : super(key: key);

  @override
  _TrainingPageState createState() => _TrainingPageState();
}

class _TrainingPageState extends State<TrainingPage> {
  bool firsttime = true;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _pageController = PageController(initialPage: 0, keepPage: true);
  num page = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        page = _pageController.page;
      });
    });
  }

  Widget pageCircle(int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      height: 10,
      width: 10,
      decoration: BoxDecoration(
        color: page.round() == index ? Color.fromRGBO(255, 70, 70, 1) : Colors.black,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = AppStateContainer.of(context).blocProvider;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(0, 0, 0, 1),
        title: Text(
          "Training",
          style: TextStyle(color: Color.fromRGBO(255, 70, 70, 1)),
        ),
      ),
      bottomNavigationBar: Container(
        height: 30,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(2, (index) => pageCircle(index)),
        ),
      ),
      body: StreamBuilder<TrainingEvent>(
        stream: bloc.trainingBloc.trainingStream,
        builder: (context, snapshot) {
          TrainingEvent trainingEvent;
          if (snapshot.hasData == false) {
            trainingEvent = bloc.trainingBloc.lastEvent;
            if (trainingEvent == null || trainingEvent?.isTraining == false) return LinearProgressIndicator();
          } else {
            trainingEvent = snapshot.data;
          }
          if (trainingEvent.isTraining == false) {
            return Container(color: Colors.black);
          }
          return PageView(
            controller: _pageController,
            children: [
              AddSeriePage(trainingEvent: trainingEvent),
              SeriesListPage(trainingEvent: trainingEvent),
            ],
          );
        },
      ),
    );
  }
}
