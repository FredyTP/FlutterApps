//                   GNU GENERAL PUBLIC LICENSE
//                    Version 3, 29 June 2007

//Copyright (C) 2007 Free Software Foundation, Inc. <https://fsf.org/>
//Everyone is permitted to copy and distribute verbatim copies
// of this license document, but changing it is not allowed.
//Author: Alfredo Torres Pons

import 'dart:io';
import 'dart:math';

import 'package:filepicker_windows/filepicker_windows.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:hyperloop_datastruct_generation/DataType.dart';
import 'package:hyperloop_datastruct_generation/variable.dart';
import 'package:hyperloop_datastruct_generation/variable_tree.dart';

import 'CodeGeneration.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  VariableTree variableTree = VariableTree();
  List<DataType> dataTypeList = [
    DataType("uint8_t", 1, "getUint8"),
    DataType("uint16_t", 2, "getUint16"),
    DataType("uint32_t", 4, "getUint32"),
    DataType("int8_t", 1, "getInt8"),
    DataType("int16_t", 2, "getInt16"),
    DataType("int32_t", 4, "getInt32"),
    DataType("float", 4, "getFloat32"),
    DataType("double", 8, "getFloat64"),
    DataType("struct", 0, "parseStruct¿?"),
  ];
  Variable editingVar;
  DataType lastDataType = DataType.float();

  //-------COLORS----------//
  final Color varTypeColor = Color.fromRGBO(190, 232, 160, 1.0);
  final Color structTypeColor = Color.fromRGBO(245, 156, 154, 1.0);
  final Color varNameColor = Color.fromRGBO(245, 214, 162, 1.0);
  final Color lenColor = Color.fromRGBO(170, 239, 242, 1.0);
  final Color deleteDialogBGColor = Color.fromRGBO(40, 40, 40, 0.95);
  final Color deleteDialogFontColor = Color.fromRGBO(220, 220, 220, 1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Stack(children: [
          Positioned.fill(
            child: Image.asset(
              "assets/img/Shaping_the_future-03.png",
              isAntiAlias: true,
            ),
          ),
          Image.asset("assets/img/Logo_Hyperloop_UPV-27.png"),
        ])),
        actions: appBarActions(),
      ),
      body: GestureDetector(
        onTap: () => setState(() => unSelect()),
        child: Container(
          color: Color.fromRGBO(55, 55, 55, 1.0),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              buildStructureInfoWidget(),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/img/Logo_Hyperloop_UPV-07.png"),
                      fit: BoxFit.contain,
                      scale: 0.2,
                    ),
                  ),
                  child: ListView(
                    children: generateWidgetTree(context, variableTree.varlist),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

//-----------STRUCTURE USEFUL INFORMATION-----------//
  Container buildStructureInfoWidget() {
    return Container(
      color: Color.fromRGBO(55, 55, 55, 1.0),
      child: Row(
        children: [
          buildInfoTextRound("Number of Variables: ${variableTree.numVariables()}"),
          buildInfoTextRound("Structure Size in Bytes: ${variableTree.size()}"),
          buildInfoTextRound("Structure Max Depth: ${variableTree.maxDepth()}"),
        ],
      ),
    );
  }

  Expanded buildInfoTextRound(String text) {
    return Expanded(
      child: roundedContainer(
        child: Text(
          text,
          style: TextStyle(color: Colors.black, fontSize: 17),
        ),
        color: Color.fromRGBO(230, 230, 230, 1.0),
      ),
    );
  }

//----------------APPBAR---------------//
  List<Widget> appBarActions() {
    final barcolor = Color.fromRGBO(150, 150, 150, 1.0);
    final divider = VerticalDivider(color: barcolor, indent: 10, endIndent: 10);
    final textStyle = TextStyle(fontSize: 15, color: Color.fromRGBO(230, 230, 230, 1.0));
    return [
      FlatButton(onPressed: loadDataStructure, child: Text("Load Data Structure", style: textStyle)),
      divider,
      FlatButton(onPressed: saveDataStructure, child: Text("Save Data Structure", style: textStyle)),
      divider,
      FlatButton(onPressed: saveGeneratedCode, child: Text("Generate Code", style: textStyle)),
    ];
  }

  void saveGeneratedCode() async {
    File file = File("${variableTree.headnode.name}_generated.js");
    final codeGen = TSCodeGenerator();
    await file.writeAsString(codeGen.generateCode(variableTree.headnode));
    File filec = File("${variableTree.headnode.name}_generated.h");
    await filec.writeAsString(generateCCode(variableTree.headnode));
  }

  void saveDataStructure() async {
    var saveFile = SaveFilePicker();
    saveFile.filterSpecification = {"HLDataStructure": "*.hlds"};
    saveFile.defaultExtension = "hlds";
    var result = saveFile.getFile();
    if (result != null) await result.writeAsString(variableTree.toJson());
  }

  void loadDataStructure() async {
    var openFile = OpenFilePicker();
    openFile.filterSpecification = {"HLDataStructure": "*.hlds"};
    openFile.defaultExtension = "hlds";
    var result = openFile.getFile();
    if (result != null) variableTree.loadJson(await result.readAsString());
    setState(() {});
  }

//------------------STRUCTURE TREE---------------------//
  Color getDepthColor(int depth) {
    return Color.fromRGBO(230 - 10 * depth, 230 - 7 * depth, 230 - 2 * depth, 1.0);
  }

  Widget roundedContainer({Widget child, Color color}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      margin: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      child: child,
      decoration: BoxDecoration(border: Border.all(), borderRadius: BorderRadius.circular(10), color: color),
      alignment: Alignment.center,
    );
  }

  Widget addNewVariableButton(List<Variable> varlist) {
    return FlatButton.icon(
        onPressed: () {
          editingVar = Variable(name: "", type: lastDataType, children: List<Variable>.empty(growable: true));
          varlist.add(editingVar);
          setState(() {});
        },
        icon: Icon(Icons.add_circle, color: Color.fromRGBO(0, 0, 0, 1.0)),
        label: Text(""));
  }

  Widget variableEditField({Variable variable, void Function(String) onChanged, Color color, String initialText, String labelText}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      child: TextFormField(
        decoration: InputDecoration(
            filled: true,
            fillColor: color,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 1),
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 1),
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            hintText: labelText,
            labelText: labelText,
            labelStyle: TextStyle(color: Colors.black)),
        cursorColor: Colors.black,
        initialValue: initialText,
        onFieldSubmitted: (value) {
          unSelect();
        },
        onChanged: (value) => onChanged(value),
      ),
    );
  }

  Widget createVariableWidget(BuildContext context, Variable variable, int depth) {
    Widget child;
    Widget children = SizedBox.shrink();
    if (variable.type.type == "struct" && variable.children != null && variable.hide == false) {
      children = Column(
        children: variable.children.map<Widget>((element) {
          return Padding(
            padding: const EdgeInsets.only(left: 28.0),
            child: createVariableWidget(context, element, depth + 1),
          );
        }).toList()
          ..add(addNewVariableButton(variable.children)),
      );
    }
    if (editingVar == variable) {
      child = editVariableWidget(context, variable, children, getDepthColor(depth));
    } else {
      child = variableWidget(context, variable, children, getDepthColor(depth));
    }
    return child;
  }

  Widget variableWidget(BuildContext context, Variable variable, Widget children, Color color) {
    return roundedContainer(
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  editingVar = variable;
                });
              },
              child: roundedContainer(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      variable.isStruct()
                          ? IconButton(
                              icon: Icon(variable.hide ? Icons.arrow_forward_outlined : Icons.arrow_downward_outlined),
                              onPressed: () => setState(() => variable.hide = !variable.hide),
                            )
                          : SizedBox.shrink(),
                      roundedContainer(child: Text(variable.type.type), color: varTypeColor),
                      variable.isStruct() ? roundedContainer(child: Text(variable.structType), color: structTypeColor) : SizedBox.shrink(),
                      roundedContainer(child: Text(variable.name), color: varNameColor),
                      variable != variableTree.headnode ? roundedContainer(child: Text("[${variable.arrayLen.toString()}]"), color: lenColor) : SizedBox.shrink(),
                      variable.isStruct() && variable.hide == true ? Text("${variable.children.length} items") : SizedBox.shrink(),
                      SizedBox(width: 20),
                      variable != variableTree.headnode
                          ? IconButton(
                              icon: Transform.rotate(angle: pi / 4, child: Icon(Icons.add_circle, color: Colors.red)),
                              onPressed: () {
                                deleteVariableCallback(context, variable);
                              },
                            )
                          : SizedBox.shrink(),
                    ],
                  ),
                  color: Color.fromRGBO(160, 173, 219, 1)),
            ),
            children
          ],
        ),
        color: color);
  }

  void deleteVariableCallback(BuildContext context, Variable variable) async {
    if (variable.isStruct() && variable.children.length > 0) {
      final shouldDelete = await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                backgroundColor: deleteDialogBGColor,
                content: Text(
                  "You are going to delete ${variable.name} and all its content (${Variable.numVariables(variable.children, 0)} elements).\n Do you want to continue?",
                  style: TextStyle(color: deleteDialogFontColor),
                ),
                title: Text(
                  "Delete Struct",
                  style: TextStyle(color: deleteDialogFontColor),
                ),
                elevation: 10,
                actions: [
                  RaisedButton(
                    color: Colors.red,
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Delete", style: TextStyle(color: deleteDialogFontColor, fontSize: 17)),
                    ),
                  ),
                  FlatButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Cancel", style: TextStyle(color: deleteDialogFontColor, fontSize: 17)),
                    ),
                  )
                ],
              );
            },
          ) ??
          false;
      if (shouldDelete) {
        setState(() {
          variableTree.deleteVariable(variable);
        });
      }
    } else {
      setState(() {
        variableTree.deleteVariable(variable);
      });
    }
  }

  Widget editVariableWidget(BuildContext context, Variable variable, Widget children, Color color) {
    return roundedContainer(
        child: Container(
          child: Column(
            children: [
              Row(
                children: [
                  roundedContainer(child: dataTypeSelector(), color: varTypeColor),
                  editingVar.type.type == "struct"
                      ? Expanded(
                          flex: 3,
                          child: variableEditField(
                              variable: variable,
                              onChanged: (value) {
                                setState(() {
                                  variable.structType = value;
                                  editingVar = variable;
                                });
                              },
                              initialText: variable.structType,
                              labelText: "Struct Type",
                              color: structTypeColor),
                        )
                      : SizedBox.shrink(),
                  Expanded(
                    flex: 3,
                    child: variableEditField(
                      variable: variable,
                      onChanged: (value) {
                        setState(() {
                          variable.name = value;
                          editingVar = variable;
                        });
                      },
                      initialText: variable.name,
                      labelText: "Variable Name",
                      color: varNameColor,
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: variable != variableTree.headnode
                        ? variableEditField(
                            variable: variable,
                            onChanged: (value) {
                              setState(() {
                                variable.arrayLen = int.tryParse(value) ?? 1;
                                editingVar = variable;
                              });
                            },
                            labelText: "Array Lenght",
                            initialText: variable.arrayLen.toString(),
                            color: lenColor,
                          )
                        : SizedBox(),
                  ),
                ],
              ),
              children,
            ],
          ),
        ),
        color: color);
  }

  List<Widget> generateWidgetTree(BuildContext context, List<Variable> varlist) {
    return varlist.map((e) => createVariableWidget(context, e, 0)).toList();
  }

  Widget dataTypeSelector() {
    return DropdownButton<String>(
      items: dataTypeList
          .map((e) => DropdownMenuItem(
                child: Text(e.type),
                value: e.type,
                //onTap: () => setState(() => editingVar.type = e),
              ))
          .toList(),
      value: editingVar.type.type,
      onChanged: (value) {
        setState(() => editingVar.type = dataTypeList.firstWhere((element) => element.type == value));
        lastDataType = editingVar.type;
      },
    );
  }

  void unSelect() {
    setState(() {
      editingVar = null;
    });
  }
}
