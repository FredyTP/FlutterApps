import 'package:GymStats/src/app_state.dart';
import 'package:GymStats/src/bloc/gym/training_bloc.dart';
import 'package:GymStats/src/model/serie_model.dart';
import 'package:GymStats/src/widgets/logic/async_raised_button.dart';
import 'package:GymStats/src/widgets/logic/exercise_image.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class AddSeriePage extends StatefulWidget {
  final TrainingEvent trainingEvent;
  AddSeriePage({key, this.trainingEvent}) : super(key: key);

  @override
  _AddSeriePageState createState() => _AddSeriePageState();
}

class _AddSeriePageState extends State<AddSeriePage> {
  bool isAdd = true;

  @override
  Widget build(BuildContext context) {
    final bloc = AppStateContainer.of(context).blocProvider;
    final trainingEvent = widget.trainingEvent;
    return Container(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Column(
            children: [
              Expanded(
                flex: 16,
                child: Card(
                  elevation: 5,
                  margin: EdgeInsets.all(10),
                  child: Container(
                    height: 400,
                    child: Column(
                      children: [
                        Expanded(flex: 5, child: buildTitle(trainingEvent)),
                        Divider(
                          indent: 20,
                          endIndent: 20,
                          height: 0,
                          color: Colors.black,
                        ),
                        Expanded(flex: 3, child: buildSelectRepeticiones(bloc.trainingBloc)),
                        Expanded(flex: 3, child: buildSelectWeight(bloc.trainingBloc)),
                        Expanded(flex: 4, child: buildSelectWeightMenu(bloc.trainingBloc, isAdd)),
                        Expanded(
                          flex: 2,
                          child: Center(
                            child: AsyncRaisedButton(
                              color: Colors.blue,
                              textColor: Colors.white,
                              disabledColor: Colors.grey,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                              //this is kinda useless, could be just .addSerie()
                              //Add some feedback when added
                              onPressed: () async => await bloc.trainingBloc.addSerie(SerieModel(
                                exerciseID: trainingEvent.currentExercise.id,
                                reps: bloc.trainingBloc.exerciseReps,
                                weight: bloc.trainingBloc.exerciseWeight,
                                timestamp: DateTime.now(),
                              )),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Añadir Serie",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: LinearProgressIndicator(
                    backgroundColor: Color.fromRGBO(30, 30, 30, 1),
                    valueColor: AlwaysStoppedAnimation<Color>(Color.fromRGBO(250, 100, 50, 1)),
                    value: (trainingEvent.activeExerciseIdx + 1) / trainingEvent.workoutModel.exerciseIDList.length,
                  )),
              Container(
                padding: EdgeInsets.only(right: 20, top: 10),
                alignment: Alignment.centerRight,
                child: Text(
                  (trainingEvent.activeExerciseIdx + 1).toString() + "/" + trainingEvent.workoutModel.exerciseIDList.length.toString(),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  child: Center(
                    child: AsyncRaisedButton(
                      disabledColor: Colors.grey,
                      color: Colors.red,
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      onPressed: () async {
                        await bloc.trainingBloc.endTraining();
                        Navigator.of(context).pop();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Finalizar Entrenamiento",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          bloc.trainingBloc.isFirstExercise
              ? Container()
              : Positioned(
                  top: MediaQuery.of(context).size.height * 0.68,
                  left: 20,
                  child: FloatingActionButton(
                    elevation: 8,
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.red,
                    ),
                    backgroundColor: Colors.black,
                    onPressed: () {
                      bloc.trainingBloc.goLastExercise();
                    },
                  ),
                ),
          bloc.trainingBloc.isLastExercise
              ? Container()
              : Positioned(
                  top: MediaQuery.of(context).size.height * 0.68,
                  right: 20,
                  child: FloatingActionButton(
                    elevation: 8,
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.red,
                    ),
                    backgroundColor: Colors.black,
                    onPressed: () {
                      bloc.trainingBloc.goNextExercise();
                    },
                  ),
                )
        ],
      ),
    );
  }

  final weights = [1, 1.25, 2.5, 5, 10, 20];
  Widget buildSelectWeightMenu(TrainingBloc trainingBloc, bool add) {
    return Container(
      padding: EdgeInsets.all(15),
      width: double.infinity,
      child: Center(
        child: Wrap(
          spacing: 10,
          runSpacing: 10,
          direction: Axis.horizontal,
          children: List.generate(
            weights.length,
            (index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    trainingBloc.addWeight(weights[index] * (isAdd ? 1 : -1));
                  });
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    width: 100,
                    padding: EdgeInsets.all(10),
                    color: isAdd ? Colors.green : Colors.red,
                    child: Center(
                      child: AutoSizeText(
                        (isAdd ? "+" : "-") + weights[index].toString(),
                        maxLines: 1,
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildSelectWeight(TrainingBloc trainingBloc) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            flex: 4,
            child: Center(
              child: Text(
                "Peso:",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                trainingBloc.exerciseWeight.toString(),
                style: TextStyle(fontSize: 25),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
              children: [
                IconButton(
                  color: Colors.red,
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    setState(() {
                      isAdd = false;
                    });
                  },
                ),
                SizedBox(
                  width: 10,
                ),
                IconButton(
                  color: Colors.green,
                  icon: Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      isAdd = true;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSelectRepeticiones(TrainingBloc trainingBloc) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            flex: 4,
            child: Center(
              child: Text(
                "Repeticiones:",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                trainingBloc.exerciseReps.toString(),
                style: TextStyle(fontSize: 25),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
              children: [
                IconButton(
                  color: Colors.red,
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    setState(() {
                      trainingBloc.addReps(-1);
                    });
                  },
                ),
                SizedBox(
                  width: 10,
                ),
                IconButton(
                  color: Colors.green,
                  icon: Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      trainingBloc.addReps(1);
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTitle(TrainingEvent trainingEvent) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(right: 10),
              child: AutoSizeText(
                trainingEvent.currentExercise.name,
                maxLines: 4,
                maxFontSize: 30,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: ExerciseImage(
                imgPath: trainingEvent.currentExercise.imagePath,
              ),
            ),
          )
        ],
      ),
    );
  }
}
