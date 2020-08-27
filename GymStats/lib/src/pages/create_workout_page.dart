import 'package:GymStats/src/app_state.dart';
import 'package:GymStats/src/bloc/bloc_provider.dart';
import 'package:GymStats/src/model/exercise_model.dart';
import 'package:GymStats/src/model/workout_model.dart';
import 'package:GymStats/src/widgets/logic/exercise_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CreateWorkoutPage extends StatefulWidget {
  CreateWorkoutPage({Key key}) : super(key: key);
  static const route = "CreateWorkoutPage";

  @override
  _CreateWorkoutPageState createState() => _CreateWorkoutPageState();
}

class _CreateWorkoutPageState extends State<CreateWorkoutPage> {
  final _exerciseList = List<ExerciseModel>();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool blockButton = false;
  @override
  Widget build(BuildContext context) {
    final bloc = AppStateContainer.of(context).blocProvider;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Create Workout"),
        actions: [
          FlatButton(
            child: Text("Crear Workout"),
            onPressed: blockButton || _exerciseList.length == 0
                ? null
                : () async {
                    setState(() {
                      blockButton = true;
                    });
                    final name = await _showSetNamePopup(context);
                    if (name != null) {
                      await bloc.workoutBloc.addWorkout(
                        uid: bloc.appUserBloc.currentUser.userData.id,
                        workout: WorkoutModel(exerciseIDList: _exerciseList.map((e) => e.id).toList(), name: name),
                      );
                      Navigator.of(context).pop();
                    } else {
                      setState(() {
                        blockButton = false;
                      });
                    }
                  },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              child: DragTarget<ExerciseModel>(
                onWillAccept: (_) => true,
                onAccept: (data) {
                  setState(() {
                    _exerciseList.add(data);
                  });
                },
                builder: (context, candidateData, rejectedData) {
                  return ListView.separated(
                    separatorBuilder: (context, index) => Divider(
                      height: 0,
                      indent: 20,
                      endIndent: 20,
                    ),
                    itemCount: _exerciseList.length,
                    itemBuilder: (context, index) {
                      final exercise = _exerciseList[index];
                      return buildExerciseTile(exercise, index);
                    },
                  );
                },
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.grey,
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: buildDraggableList(bloc),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildExerciseTile(ExerciseModel exercise, int index) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 5),
              child: VerticalDivider(),
            ),
            Padding(
              padding: EdgeInsets.only(right: 10),
              child: Icon(
                Icons.delete_forever,
                size: 30,
              ),
            ),
          ],
        ),
      ),
      onDismissed: (direction) {
        setState(() {
          _exerciseList.removeAt(index);
        });
      },
      child: ListTile(
        title: Text(exercise.name),
      ),
    );
  }

  StreamBuilder<QuerySnapshot> buildDraggableList(BlocProvider bloc) {
    return StreamBuilder(
      stream: bloc.exerciseBloc.getExercisesStream(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          final exerciseList = snapshot.data;
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 15, mainAxisSpacing: 15),
            itemCount: exerciseList.docs.length,
            itemBuilder: (context, index) {
              final exercise = ExerciseModel.fromFirebase(exerciseList.docs[index]);

              return buildDraggableItem(exercise);
            },
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  Draggable<ExerciseModel> buildDraggableItem(ExerciseModel exercise) {
    return LongPressDraggable<ExerciseModel>(
      dragAnchor: DragAnchor.child,
      data: exercise,
      child: buildExerciseCard(exercise),
      childWhenDragging: Container(),
      feedback: buildFeedbackCard(exercise),
    );
  }

  Widget buildFeedbackCard(ExerciseModel exercise) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      clipBehavior: Clip.antiAlias,
      elevation: 7,
      child: Container(
        height: 100,
        width: 100,
      ),
    );
  }

  Card buildExerciseCard(ExerciseModel exercise) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 7,
      color: Color.fromRGBO(250, 190, 120, 1),
      child: GridTile(
        child: ExerciseImage(
          imgPath: exercise.imagePath,
          fit: BoxFit.fitWidth,
          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes : null,
              ),
            );
          },
        ),
        footer: Container(width: double.infinity, color: Colors.amber, alignment: Alignment.center, padding: EdgeInsets.all(12), child: Text(exercise.name)),
      ),
    );
  }

  Future<String> _showSetNamePopup(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) {
        String name;
        return AlertDialog(
          actions: [
            RaisedButton(
              color: Colors.green,
              onPressed: () => Navigator.of(context).pop(name),
              child: Text("Aceptar"),
            ),
            FlatButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancelar"),
            )
          ],
          content: ListTile(
            title: TextFormField(
                decoration: InputDecoration(
                  labelText: "User Name",
                  labelStyle: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(6))),
                  helperText: "User Name :",
                ),
                onChanged: (value) {
                  name = value;
                }),
          ),
        );
      },
    );
  }
}
