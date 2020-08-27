import 'dart:io';

import 'package:GymStats/src/app_state.dart';
import 'package:GymStats/src/enum/equipment_enum.dart';
import 'package:GymStats/src/enum/muscle_enum.dart';
import 'package:GymStats/src/model/exercise_model.dart';
import 'package:GymStats/src/widgets/logic/async_raised_button.dart';
import 'package:GymStats/src/widgets/logic/exercise_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddExercisePage extends StatefulWidget {
  final ExerciseModel exercise;
  AddExercisePage({Key key, this.exercise}) : super(key: key);

  @override
  _AddExercisePageState createState() => _AddExercisePageState();
}

class _AddExercisePageState extends State<AddExercisePage> {
  bool haveImage = false;
  String imgPath;
  String name = "";
  String description = "";
  List<Muscles> primaryMuscles = [];
  List<Muscles> secondaryMuscles = [];
  List<Equipment> equipment = [];

  var result;

  List<bool> expandedList = [false, false, false];

  final _formKey = GlobalKey<FormState>();

  File pickedImg;

  @override
  void initState() {
    super.initState();
    if (widget.exercise != null) {
      imgPath = widget.exercise.imagePath ?? "";
      name = widget.exercise.name ?? "";
      description = widget.exercise.description ?? "";
      primaryMuscles = widget.exercise.primaryMuscles ?? [];
      secondaryMuscles = widget.exercise.secondaryMuscles ?? [];
      equipment = widget.exercise.equipment ?? [];

      if (widget.exercise.imagePath != null) haveImage = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = AppStateContainer.of(context).blocProvider;
    return Scaffold(
      appBar: AppBar(
        title: Text("Añadir Ejercicio"),
      ),
      body: Container(
        child: ListView(
          children: [
            Container(
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  buildImage(context),
                  buildImageButtons(context)
                ],
              ),
            ),
            Divider(color: Colors.black, indent: 20, endIndent: 20),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    child: TextFormField(
                      onSaved: (newValue) {
                        name = newValue;
                      },
                      initialValue: name,
                      validator: (value) {
                        if (value == null || value.length < 3) {
                          return "Nombre demasiado corto";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.title),
                        labelText: "Nombre",
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: TextFormField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      validator: (value) {
                        return null;
                      },
                      onSaved: (newValue) {
                        description = newValue;
                      },
                      initialValue: description,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.title),
                        labelText: "Descripción",
                      ),
                    ),
                  ),
                ],
              ),
            ),
            buidSelectItemsFromEnum(
              "Musculos Primarios",
              expandedList,
              0,
              primaryMuscles,
              Muscles.values,
              (item) => secondaryMuscles.contains(item as Muscles) || primaryMuscles.contains((item as Muscles)),
            ),
            buidSelectItemsFromEnum(
              "Musculos Secundarios",
              expandedList,
              1,
              secondaryMuscles,
              Muscles.values,
              (item) => secondaryMuscles.contains(item as Muscles) || primaryMuscles.contains((item as Muscles)),
            ),
            buidSelectItemsFromEnum(
              "Equipamiento",
              expandedList,
              2,
              equipment,
              Equipment.values,
              (item) => equipment.contains(item as Equipment),
            ),
            Center(
              child: AsyncRaisedButton(
                child: Text("Enviar"),
                color: Colors.green,
                textColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                disabledColor: Colors.grey,
                onPressed: () async {
                  print(_formKey.currentState.toString());
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    print(name);

                    String path;
                    if (haveImage) {
                      if (pickedImg != null) {
                        //img loaded from phone
                        path = await bloc.storageBloc.uploadExerciseImg(pickedImg);
                      } else {
                        //img already in db
                        path = imgPath;
                      }
                    } else {
                      //no image
                      path = null;
                    }
                    if (widget.exercise == null) {
                      await bloc.exerciseBloc.addExersice(ExerciseModel(
                        description: description,
                        name: name,
                        primaryMuscles: primaryMuscles,
                        secondaryMuscles: secondaryMuscles,
                        equipment: equipment,
                        imagePath: path,
                      ));
                    } else {
                      await bloc.exerciseBloc.updateExercise(ExerciseModel(
                        id: widget.exercise.id,
                        description: description,
                        name: name,
                        primaryMuscles: primaryMuscles,
                        secondaryMuscles: secondaryMuscles,
                        equipment: equipment,
                        imagePath: path,
                      ));
                    }
                    try {
                      Navigator.of(context).pop();
                    } catch (e) {
                      print(e);
                    }
                  }
                },
              ),
            ),
            SizedBox(height: 20),
            widget.exercise != null
                ? Center(
                    child: AsyncRaisedButton(
                    child: Text("Eliminar"),
                    color: Colors.red,
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    disabledColor: Colors.grey,
                    onPressed: () async {
                      await bloc.exerciseBloc.deleteExercise(widget.exercise);
                      Navigator.of(context).pop();
                    },
                  ))
                : Container()
          ],
        ),
      ),
    );
  }

  Widget buildImageButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        haveImage
            ? Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: RaisedButton(
                  color: Colors.red,
                  textColor: Colors.white,
                  child: Text("Eliminar Imágen"),
                  onPressed: () {
                    setState(() {
                      pickedImg = null;
                      haveImage = false;
                      imgPath = null;
                    });
                  },
                ),
              )
            : SizedBox.shrink(),
        AsyncRaisedButton(
          child: Text("Selectionar Imágen"),
          onPressed: () async {
            final bloc = AppStateContainer.of(context).blocProvider;
            pickedImg = await bloc.exerciseBloc.pickImageFromGallery();
            if (pickedImg != null) {
              haveImage = true;
            }
            setState(() {});
          },
        ),
      ],
    );
  }

  Widget buildImage(BuildContext context) {
    Widget image;
    if (haveImage) {
      if (pickedImg != null) {
        image = Image.file(pickedImg, fit: BoxFit.fitHeight);
      } else {
        image = ExerciseImage(imgPath: imgPath, fit: BoxFit.fitHeight);
      }
    } else {
      image = Image.asset("assets/aspect_ratio.png", fit: BoxFit.fitHeight);
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.width * 0.9 * 3 / 5,
        child: image,
      ),
    );
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
}
