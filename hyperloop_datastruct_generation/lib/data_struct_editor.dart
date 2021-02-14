import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hyperloop_datastruct_generation/Model/BoardModel.dart';
import 'package:hyperloop_datastruct_generation/Model/variable_tree.dart';
import 'package:hyperloop_datastruct_generation/color_data.dart';

import 'Model/DataType.dart';
import 'Model/variable.dart';

class DataStructEditor extends StatefulWidget {
  final BoardModel board;
  final VariableTree variableTree;
  DataStructEditor({Key key, this.variableTree, this.board}) : super(key: key);

  @override
  DataStructEditorState createState() => DataStructEditorState();
}

class DataStructEditorState extends State<DataStructEditor> {
  Variable editingVar;
  DataType lastDataType = DataType.float();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(35, 35, 35, 1.0),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: widget.board == null
            ? [
                buildInfoTextRound(text: "No Board Available", color: ColorData.varTypeColor, textColor: Colors.white),
              ]
            : [
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
                      children: generateWidgetTree(context, widget.variableTree.varlist),
                    ),
                  ),
                ),
              ],
      ),
    );
  }

  Color getDepthColor(int depth) {
    return Color.fromRGBO(230 - 10 * depth, 230 - 7 * depth, 230 - 2 * depth, 1.0);
  }

  Expanded buildInfoTextRound({String text, Color color = ColorData.lenColor, Color textColor = Colors.black}) {
    return Expanded(
      child: roundedContainer(
        child: Text(
          text,
          style: TextStyle(color: textColor, fontSize: 16),
        ),
        color: color,
      ),
    );
  }

  Container buildStructureInfoWidget() {
    return Container(
      color: Color.fromRGBO(55, 55, 55, 1.0),
      child: Column(
        children: [
          Row(
            children: [
              buildInfoTextRound(text: "Selected Board: ${widget.board.name}", color: ColorData.varTypeColor, textColor: Colors.white),
            ],
          ),
          Row(
            children: [
              buildInfoTextRound(text: "Number of Variables: ${widget.variableTree.numVariables()}"),
              buildInfoTextRound(text: "Structure Size: ${widget.variableTree.size()} Byte"),
              buildInfoTextRound(text: "Structure Max Depth: ${widget.variableTree.maxDepth()}"),
            ],
          ),
        ],
      ),
    );
  }

  Widget roundedContainer({Widget child, Color color, bool border = true}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      margin: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      child: child,
      decoration: BoxDecoration(border: border ? Border.all() : null, borderRadius: BorderRadius.circular(10), color: color),
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

  Widget variableEditField({Variable variable, void Function(String) onChanged, Color color, String initialText, String labelText, bool light = false, bool autofocus = false}) {
    return roundedContainer(
      border: false,
      color: color,
      child: TextFormField(
        autofocus: autofocus,
        style: TextStyle(color: light ? ColorData.nameFontColor : Colors.black),
        decoration: InputDecoration(
            filled: true,
            fillColor: color,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: light ? Color.fromRGBO(150, 156, 170, 1) : Colors.black, width: 1),
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: light ? ColorData.nameFontColor : Colors.black, width: 1),
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            hintText: labelText,
            labelText: labelText,
            hintStyle: TextStyle(color: light ? ColorData.nameFontColor : Colors.black),
            labelStyle: TextStyle(color: light ? ColorData.nameFontColor : Colors.black)),
        cursorColor: Colors.black,
        initialValue: initialText,
        onFieldSubmitted: (value) {
          unSelect();
        },
        onChanged: (value) => onChanged(value),
      ),
    );
  }

  Widget createVariableWidget(BuildContext context, Variable variable, int depth, Variable parent) {
    Widget child;
    Widget children = SizedBox.shrink();
    if (variable.type.type == "struct" && variable.children != null && variable.hide == false) {
      children = Column(
        children: variable.children.map<Widget>((element) {
          return Padding(
            padding: const EdgeInsets.only(left: 28.0),
            child: createVariableWidget(context, element, depth + 1, variable),
          );
        }).toList()
          ..add(addNewVariableButton(variable.children)),
      );
    }
    if (editingVar == variable) {
      child = editVariableWidget(context, variable, children, getDepthColor(depth), parent);
    } else {
      child = variableWidget(context, variable, children, getDepthColor(depth));
    }
    return child;
  }

  Widget variableWidget(BuildContext context, Variable variable, Widget children, Color color) {
    final widged = GestureDetector(
        onTap: () {
          setState(() {
            editingVar = variable;
          });
        },
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: roundedContainer(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                variable.isStruct()
                    ? IconButton(
                        icon: Icon(
                          variable.hide ? Icons.arrow_forward_outlined : Icons.arrow_downward_outlined,
                          color: ColorData.dropdownArrowColor,
                        ),
                        onPressed: () => setState(() => variable.hide = !variable.hide),
                      )
                    : SizedBox.shrink(),
                roundedContainer(child: Text(variable.type.type, style: TextStyle(color: ColorData.nameFontColor)), color: ColorData.varTypeColor),
                variable.isStruct() ? roundedContainer(child: Text(variable.structType, style: TextStyle(color: ColorData.nameFontColor)), color: ColorData.structTypeColor) : SizedBox.shrink(),
                variable.isEnum() ? roundedContainer(child: Text(variable.enumName, style: TextStyle(color: ColorData.nameFontColor)), color: ColorData.structTypeColor) : SizedBox.shrink(),
                roundedContainer(
                    child: Text(
                      variable.name,
                    ),
                    color: ColorData.varNameColor),
                variable != widget.variableTree.headnode ? roundedContainer(child: Text("[${variable.arrayLen.toString()}]"), color: ColorData.lenColor) : SizedBox.shrink(),
                variable.isStruct() && variable.hide == true
                    ? Text(
                        "${variable.children.length} items",
                        style: TextStyle(color: ColorData.nameFontColor),
                      )
                    : SizedBox.shrink(),
                SizedBox(width: 20),
                variable != widget.variableTree.headnode
                    ? IconButton(
                        icon: Transform.rotate(angle: pi / 4, child: Icon(Icons.add_circle, color: Colors.red)),
                        onPressed: () {
                          deleteVariableCallback(context, variable);
                        },
                      )
                    : SizedBox.shrink(),
              ],
            ),
            color: ColorData.boxColor,
          ),
        ));
    if (variable.isStruct()) {
      return roundedContainer(
          child: Column(
            children: [widged, children],
          ),
          color: color);
    } else {
      return widged;
    }
  }

  void deleteVariableCallback(BuildContext context, Variable variable) async {
    if (variable.isStruct() && variable.children.length > 0) {
      final shouldDelete = await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                backgroundColor: ColorData.deleteDialogBGColor,
                content: Text(
                  "You are going to delete ${variable.name} and all its content (${Variable.numVariables(variable.children, 0)} elements).\n Do you want to continue?",
                  style: TextStyle(color: ColorData.deleteDialogFontColor),
                ),
                title: Text(
                  "Delete Struct",
                  style: TextStyle(color: ColorData.deleteDialogFontColor),
                ),
                elevation: 10,
                actions: [
                  RaisedButton(
                    color: Colors.red,
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Delete", style: TextStyle(color: ColorData.deleteDialogFontColor, fontSize: 17)),
                    ),
                  ),
                  FlatButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Cancel", style: TextStyle(color: ColorData.deleteDialogFontColor, fontSize: 17)),
                    ),
                  )
                ],
              );
            },
          ) ??
          false;
      if (shouldDelete) {
        setState(() {
          widget.variableTree.deleteVariable(variable);
        });
      }
    } else {
      setState(() {
        widget.variableTree.deleteVariable(variable);
      });
    }
  }

  Widget editVariableWidget(BuildContext context, Variable variable, Widget children, Color color, Variable parent) {
    final editwidget = Row(
      children: [
        variable != widget.variableTree.headnode
            ? roundedContainer(child: dataTypeSelector(), color: ColorData.varTypeColor)
            : roundedContainer(
                child: Text(
                  variable.type.type,
                  style: TextStyle(color: ColorData.nameFontColor),
                ),
                color: ColorData.varTypeColor),
        editingVar.isStruct()
            ? Expanded(
                flex: 3,
                child: variableEditField(
                    autofocus: editingVar.isStruct(),
                    light: true,
                    variable: variable,
                    onChanged: (value) {
                      setState(() {
                        variable.structType = value;
                        editingVar = variable;
                      });
                    },
                    initialText: variable.structType,
                    labelText: "Struct Type",
                    color: ColorData.structTypeColor),
              )
            : SizedBox.shrink(),
        editingVar.isEnum()
            ? Expanded(
                flex: 3,
                child: variableEditField(
                    autofocus: editingVar.isEnum(),
                    light: true,
                    variable: variable,
                    onChanged: (value) {
                      setState(() {
                        variable.enumName = value;
                        editingVar = variable;
                      });
                    },
                    initialText: variable.enumName,
                    labelText: "Enum Type",
                    color: ColorData.structTypeColor),
              )
            : SizedBox.shrink(),
        Expanded(
          flex: 3,
          child: variableEditField(
            autofocus: !(editingVar.isEnum() & editingVar.isStruct()),
            variable: variable,
            onChanged: (value) {
              setState(() {
                variable.name = value;
                editingVar = variable;
              });
            },
            initialText: variable.name,
            labelText: "Variable Name",
            color: ColorData.varNameColor,
          ),
        ),
        Expanded(
          flex: 3,
          child: variable != widget.variableTree.headnode
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
                  color: ColorData.lenColor,
                )
              : SizedBox(),
        ),
        variable == widget.variableTree.headnode
            ? SizedBox.shrink()
            : Column(
                children: [
                  IconButton(
                      icon: Icon(Icons.arrow_upward_outlined),
                      iconSize: 20,
                      onPressed: parent.children.indexOf(variable) > 0
                          ? () {
                              final index = parent.children.indexOf(variable);

                              if (index > 0) {
                                parent.children.removeAt(index);
                                parent.children.insert(index - 1, variable);
                              }
                              setState(() {});
                            }
                          : null),
                  IconButton(
                      icon: Icon(Icons.arrow_downward_outlined),
                      iconSize: 20,
                      onPressed: parent.children.indexOf(variable) < parent.children.length - 1
                          ? () {
                              final index = parent.children.indexOf(variable);

                              if (index < parent.children.length - 1) {
                                parent.children.removeAt(index);
                                parent.children.insert(index + 1, variable);
                              }
                              setState(() {});
                            }
                          : null),
                ],
              ),
      ],
    );
    final selectedColor = ColorData.boxSelectedColor;
    return roundedContainer(
        child: Container(
          child: Column(
            children: [
              variable.isStruct() ? roundedContainer(child: editwidget, color: selectedColor) : editwidget,
              children,
            ],
          ),
        ),
        color: variable.isStruct() ? color : selectedColor);
  }

  List<Widget> generateWidgetTree(BuildContext context, List<Variable> varlist) {
    return varlist.map((e) => createVariableWidget(context, e, 0, varlist.first)).toList()
      ..add(SizedBox(
        height: 300,
      ));
  }

  Widget dataTypeSelector() {
    return DropdownButton<String>(
      icon: Icon(
        // Add this
        Icons.arrow_drop_down, // Add this
        color: ColorData.nameFontColor, // Add this
      ),
      focusColor: Colors.black,
      style: TextStyle(color: ColorData.nameFontColor, fontSize: 17),
      dropdownColor: ColorData.varTypeColor,
      items: DataType.dataTypes
          .map((e) => DropdownMenuItem(
                child: Text(e.type),
                value: e.type,
                //onTap: () => setState(() => editingVar.type = e),
              ))
          .toList(),
      value: editingVar.type.type,
      onChanged: (value) {
        setState(() => editingVar.type = DataType.dataTypes.firstWhere((element) => element.type == value));
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
