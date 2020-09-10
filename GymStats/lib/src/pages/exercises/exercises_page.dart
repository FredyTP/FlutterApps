import 'package:GymStats/src/app_state.dart';
import 'package:GymStats/src/bloc/bloc_provider.dart';
import 'package:GymStats/src/enum/equipment_enum.dart';
import 'package:GymStats/src/enum/muscle_enum.dart';
import 'package:GymStats/src/model/exercise_model.dart';
import 'package:GymStats/src/pages/exercises/add_exercise_page.dart';
import 'package:GymStats/src/pages/exercises/exercise_info_page.dart';
import 'package:GymStats/src/widgets/logic/enum_chip_selector.dart';
import 'package:GymStats/src/widgets/logic/exercise_image.dart';
import 'package:GymStats/src/widgets/view/exercise_card_grid.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ExercisesPage extends StatefulWidget {
  final Function(BuildContext, ExerciseModel, Widget image) onSelect;
  final Function(BuildContext, ExerciseModel, Widget image) onLongPress;
  final bool canEdit;
  final bool canSearch;

  const ExercisesPage({Key key, this.onSelect, this.onLongPress, this.canEdit = true, this.canSearch = true}) : super(key: key);

  static const route = "ExercisesPage";

  @override
  _ExercisesPageState createState() => _ExercisesPageState();
}

class _ExercisesPageState extends State<ExercisesPage> {
  List<Muscles> filterMuscles = [];
  List<Equipment> filterEquipment = [];
  bool showFilterContainer = false;
  List<bool> openMenu = [false, false];
  @override
  Widget build(BuildContext context) {
    final bloc = AppStateContainer.of(context).blocProvider;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Ejercicios"),
        actions: [
          FlatButton.icon(
              onPressed: () => setState(() => showFilterContainer = !showFilterContainer),
              icon: Icon(
                Icons.filter_list,
                color: Colors.white,
              ),
              label: Text(
                "Filtrar",
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
      floatingActionButton: buildAddButton(),
      body: Column(
        children: [
          buildFilterMenu(),
          buildExerciseGridView(bloc),
        ],
      ),
    );
  }

  Expanded buildExerciseGridView(BlocProvider bloc) {
    return Expanded(
      child: Container(
        child: StreamBuilder(
          stream: bloc.exerciseBloc.getExercisesStream(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              final exerciseList = snapshot.data.docs;
              List filteredExerciseList = exerciseList;
              filterMuscles.forEach((muscle) {
                filteredExerciseList = filteredExerciseList.where((exercise) => ExerciseModel.fromFirebase(exercise).primaryMuscles.contains(muscle)).toList();
              });
              filterEquipment.forEach((equip) {
                filteredExerciseList = filteredExerciseList.where((exercise) => ExerciseModel.fromFirebase(exercise).equipment.contains(equip)).toList();
              });
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                itemCount: filteredExerciseList.length,
                itemBuilder: (context, index) {
                  final exercise = ExerciseModel.fromFirebase(filteredExerciseList[index]);
                  return ExerciseGridCard(
                    key: ValueKey(exercise.id),
                    exercise: exercise,
                    haveBorder: false,
                    topBorderColor: Color.lerp(Colors.white, Colors.black, index / filteredExerciseList.length),
                    onSelect: (context, exercise, image) {
                      widget.onSelect == null ? navigateToInfoPage(context, exercise, image) : widget.onSelect(context, exercise, image);
                    },
                    onLongPress: (context, exercise, image) {
                      (widget.onLongPress == null && widget.canEdit) ? navigateToEditPage(context, exercise) : widget.onLongPress(context, exercise, image);
                    },
                  );
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

  AnimatedContainer buildFilterMenu() {
    return AnimatedContainer(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Color.fromRGBO(220, 220, 220, 1),
        border: Border.all(color: Colors.black, width: 5),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
      ),
      duration: Duration(milliseconds: 400),
      curve: Curves.easeOut,
      height: showFilterContainer ? 300 : 0,
      child: ListView(
        children: [
          EnumChipSelector(
            title: "Musculos",
            enumeration: Muscles.values,
            onChange: (list) {
              setState(() {
                filterMuscles = list.cast<Muscles>();
              });
            },
          ),
          EnumChipSelector(
            title: "Equipamiento",
            enumeration: Equipment.values,
            onChange: (list) {
              setState(() {
                filterEquipment = list.cast<Equipment>();
              });
            },
          ),
        ],
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

  Widget buidSelectItemsFromEnum(String title, List<bool> expanded, int index, List<dynamic> lista, List<dynamic> enumeration, bool Function(dynamic) isSelected) {
    return Container(
      padding: EdgeInsets.all(7),
      child: Column(
        children: [
          Container(
              padding: EdgeInsets.all(10),
              child: Text(
                title,
                style: TextStyle(fontSize: 20),
              )),
          ExpansionPanelList(
            expandedHeaderPadding: EdgeInsets.all(0),
            expansionCallback: (panelIndex, isExpanded) {
              setState(() {
                expanded[index] = !isExpanded;
              });
            },
            children: [
              ExpansionPanel(
                isExpanded: expanded[index],
                headerBuilder: (context, isExpanded) {
                  return Container(
                    padding: EdgeInsets.all(7),
                    alignment: Alignment.center,
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: lista
                              ?.map((e) => Chip(
                                    deleteIcon: Transform.rotate(angle: 45 * 3.1415 / 180, child: Icon(Icons.add_circle)),
                                    onDeleted: () {
                                      setState(() {
                                        lista.remove(e);
                                      });
                                    },
                                    label: Text(e.toString().split('.').last),
                                  ))
                              ?.toList() ??
                          [Container()],
                    ),
                  );
                },
                body: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(7),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 10,
                    runSpacing: 10,
                    children: [Divider()]..addAll(enumeration.map((e) => GestureDetector(
                          onTap: () {
                            setState(() {
                              if (isSelected(e) == false) lista.add(e);
                            });
                          },
                          child: Chip(
                            backgroundColor: (isSelected(e) == false) ? Color.fromRGBO(50, 230, 100, 1) : null,
                            label: Text(e.toString().split('.').last),
                          ),
                        ))),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget buildAddButton() {
    return widget.canEdit
        ? FloatingActionButton(
            backgroundColor: Colors.black,
            child: Icon(
              Icons.add,
              color: Colors.red,
              size: 40,
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
        : Container();
  }
}
