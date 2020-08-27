import 'package:GymStats/src/app_state.dart';
import 'package:GymStats/src/model/exercise_model.dart';
import 'package:GymStats/src/pages/exercises/add_exercise_page.dart';
import 'package:GymStats/src/pages/exercises/exercise_info_page.dart';
import 'package:GymStats/src/widgets/logic/exercise_image.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ExercisesPage extends StatelessWidget {
  final Function(BuildContext, ExerciseModel) onSelect;
  final Function(BuildContext, ExerciseModel) onLongPress;
  final bool canEdit;
  const ExercisesPage({Key key, this.onSelect, this.onLongPress, this.canEdit = true}) : super(key: key);

  static const route = "ExercisesPage";

  @override
  Widget build(BuildContext context) {
    final bloc = AppStateContainer.of(context).blocProvider;
    return Scaffold(
      appBar: AppBar(
        title: Text("Ejercicios"),
        actions: [
          canEdit
              ? IconButton(
                  icon: Icon(
                    Icons.add,
                    color: Colors.red,
                    size: 30,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return AddExercisePage();
                        },
                      ),
                    );
                  },
                )
              : Container()
        ],
      ),
      body: Container(
        child: StreamBuilder(
          stream: bloc.exerciseBloc.getExercisesStream(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              final exerciseList = snapshot.data;
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                itemCount: exerciseList.docs.length,
                itemBuilder: (context, index) {
                  final exercise = ExerciseModel.fromFirebase(exerciseList.docs[index]);
                  print("id:");
                  print(exerciseList.docs[index].id);
                  return buildExerciseCard(context, exercise);
                },
              );
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }

  void navigateToInfoPage(BuildContext context, ExerciseModel exerciseModel, Widget img) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ExerciseInfoPage(
        exerciseModel: exerciseModel,
        exerciseImg: img,
      ),
    ));
  }

  void navigateToEditPage(BuildContext context, ExerciseModel exerciseModel) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => AddExercisePage(exercise: exerciseModel),
    ));
  }

  Widget buildExerciseCard(BuildContext context, ExerciseModel exercise) {
    final image = exercise.imagePath == null
        ? Container()
        : ExerciseImage(
            imgPath: exercise.imagePath,
          );
    return GestureDetector(
      onTap: () {
        if (onSelect == null)
          navigateToInfoPage(context, exercise, image);
        else {
          onSelect.call(context, exercise);
        }
      },
      onLongPress: () {
        if (onLongPress == null && canEdit) {
          navigateToEditPage(context, exercise);
        } else {
          onLongPress?.call(context, exercise);
        }
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 7,
        color: Color.fromRGBO(250, 190, 120, 1),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  color: Color.fromRGBO(200, 200, 200, 1),
                  child: image,
                ),
              ),
              Container(
                color: Colors.black,
                alignment: Alignment.center,
                padding: EdgeInsets.all(12),
                child: AutoSizeText(
                  exercise.name ?? "No Name",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
