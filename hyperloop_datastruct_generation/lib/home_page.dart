//                   GNU GENERAL PUBLIC LICENSE
//                    Version 3, 29 June 2007

//Copyright (C) 2007 Free Software Foundation, Inc. <https://fsf.org/>
//Everyone is permitted to copy and distribute verbatim copies
// of this license document, but changing it is not allowed.
//Author: Alfredo Torres Pons

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hyperloop_datastruct_generation/Model/BoardModel.dart';
import 'package:hyperloop_datastruct_generation/Model/project_model.dart';
import 'package:hyperloop_datastruct_generation/color_data.dart';
import 'package:hyperloop_datastruct_generation/custom_popup_divider.dart';

import 'package:hyperloop_datastruct_generation/data_struct_editor.dart';
import 'package:hyperloop_datastruct_generation/file_manager.dart';

import 'board_selector.dart';
import 'code/CodeGeneration.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final boardSelectorKey = GlobalKey<BoardSelectorState>();
  final structEditorKey = GlobalKey<DataStructEditorState>();
  BoardModel selectedBoard;
  FileManager fileManager;
  final ProjectModel project = ProjectModel.empty();

  //-------COLORS----------//
  final Color varTypeColor = Color.fromRGBO(170, 78, 47, 1.0);
  final Color structTypeColor = Color.fromRGBO(71, 74, 117, 1.0);
  final Color varNameColor = Color.fromRGBO(163, 163, 184, 1.0);
  final Color lenColor = Color.fromRGBO(218, 218, 226, 1.0);
  final Color deleteDialogBGColor = Color.fromRGBO(50, 50, 60, 0.95);
  final Color deleteDialogFontColor = Color.fromRGBO(220, 220, 220, 1);
  final Color nameFontColor = Color.fromRGBO(230, 230, 232, 1);
  final Color boxColor = Color.fromRGBO(50, 50, 65, 1);
  final Color dropdownArrowColor = Color.fromRGBO(163, 163, 184, 1.0);

  @override
  void initState() {
    super.initState();

    fileManager = FileManager(
      project: project,
      onLoadData: () => setState(() {}),
    );
    newProject();
  }

  void selectBoard(BoardModel model) {
    setState(() {
      selectedBoard = model;
    });
  }

  bool showBoards = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.list),
          onPressed: () {
            setState(() {
              showBoards = !showBoards;
            });
          },
        ),
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
        actions: appBarActions(context),
      ),
      body: GestureDetector(
        onTap: () {
          structEditorKey?.currentState?.unSelect();
          boardSelectorKey?.currentState?.unSelect();
        },
        child: Container(
          width: double.infinity,
          child: Row(
            children: [
              AnimatedContainer(
                width: showBoards ? 200 : 0,
                duration: Duration(milliseconds: 300),
                curve: Curves.easeOutSine,
                child: BoardSelector(
                  key: boardSelectorKey,
                  boards: project.boards,
                  selectBoard: this.selectBoard,
                  fileManager: fileManager,
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(3),
                      width: double.infinity,
                      color: ColorData.bgColor,
                      child: Center(
                        child: Text(
                          fileManager.isOpen ? "Current Project: ${project.file.path}" : "No project Open",
                          style: TextStyle(color: ColorData.nameFontColor),
                        ),
                      ),
                    ),
                    Expanded(
                      child: DataStructEditor(
                        key: structEditorKey,
                        board: selectedBoard,
                        variableTree: selectedBoard?.data,
                        project: this.project,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

//-----------STRUCTURE USEFUL INFORMATION-----------//

//----------------APPBAR---------------//
  List<Widget> appBarActions(BuildContext context) {
    final barcolor = Color.fromRGBO(150, 150, 150, 1.0);
    final divider = VerticalDivider(
      color: barcolor,
      indent: 10,
      endIndent: 10,
      width: 30,
    );
    final textStyle = TextStyle(fontSize: 15, color: Color.fromRGBO(230, 230, 230, 1.0));
    final titleStyle = TextStyle(fontSize: 20, color: Color.fromRGBO(230, 230, 230, 1.0));
    return [
      PopupMenuButton<String>(
        color: ColorData.bgColor,
        elevation: 10,
        onSelected: (value) {
          if (value == "New Project") {
            showDialog<bool>(
              context: context,
              builder: (context) {
                return AlertDialog(
                  backgroundColor: ColorData.bgColor,
                  title: Text(
                    "Do you want to save this project?",
                    style: titleStyle,
                  ),
                  actionsPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  actions: [
                    FlatButton(
                      color: Colors.green,
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text("Yes"),
                    ),
                    FlatButton(
                      color: ColorData.varTypeColor,
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text("No"),
                    ),
                    FlatButton(
                      onPressed: () => Navigator.of(context).pop(null),
                      child: Text("Cancel"),
                    ),
                  ],
                );
              },
            ).then((value) async {
              if (value == null) {
                return;
              } else if (value == true) {
                saveProject().then((value) => fileManager.isOpen ? newProject() : 0);
              } else {
                newProject();
              }
            });
          } else if (value == "Open Project") {
            openProject();
          } else if (value == "Save Project") {
            saveProject();
          } else if (value == "Save Project As") {
            saveProjectAs();
          }
        },
        child: Center(child: Text("FILE", style: textStyle)),
        tooltip: "File options",
        itemBuilder: (context) {
          final popupDivider = CustomPopupMenuDivider(
            height: 3,
            indent: 10,
            endIndent: 10,
            color: barcolor,
          );
          return [
            PopupMenuItem<String>(
              value: "New Project",
              child: Text("New Project", style: textStyle),
            ),
            popupDivider,
            PopupMenuItem<String>(
              value: "Open Project",
              child: Text("Open Project", style: textStyle),
            ),
            popupDivider,
            PopupMenuItem<String>(
              value: "Save Project",
              child: Text("Save Project", style: textStyle),
            ),
            popupDivider,
            PopupMenuItem<String>(
              value: "Save Project As",
              child: Text("Save Project As", style: textStyle),
            ),
          ];
        },
      ),
      divider,
      PopupMenuButton<String>(
        color: ColorData.bgColor,
        elevation: 10,
        onSelected: (value) {
          if (value == "Configuration") {
            showDialog(
              context: context,
              builder: (context) {
                return buildConfigDialog(context, project);
              },
            );
          } else if (value == "Info") {
            showAboutDialog(
                context: context,
                applicationName: "Hyperloop DataStruct Generator",
                applicationIcon: Image.asset(
                  "assets/img/Logo_Hyperloop_UPV-07.png",
                  height: 100,
                  color: ColorData.bgColor,
                ));
          }
        },
        child: Center(child: Text("PROJECT", style: textStyle)),
        tooltip: "File options",
        itemBuilder: (context) {
          final popupDivider = CustomPopupMenuDivider(
            height: 3,
            indent: 10,
            endIndent: 10,
            color: barcolor,
          );
          return [
            PopupMenuItem<String>(
              value: "Configuration",
              child: Text("Configuration", style: textStyle),
            ),
            popupDivider,
            PopupMenuItem<String>(
              value: "Info",
              child: Text("Info", style: textStyle),
            ),
          ];
        },
      ),
      divider,
      FlatButton(onPressed: saveCode, child: Text("GENERATE CODE", style: textStyle)),
    ];
  }

  Widget buildConfigDialog(BuildContext context, ProjectModel projectModel) {
    final size = MediaQuery.of(context).size;
    final textStyle = TextStyle(color: ColorData.nameFontColor);
    return Dialog(
      backgroundColor: ColorData.bgColor,
      child: Container(
        width: size.width * 0.7,
        height: size.height * 0.7,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                padding: EdgeInsets.all(20),
                child: Text(
                  "CONFIGURATION (Not Ready)",
                  style: TextStyle(color: ColorData.nameFontColor, fontSize: 28),
                )),
            Divider(
              height: 0,
              indent: size.width * 0.04,
              endIndent: size.width * 0.04,
              color: ColorData.nameFontColor,
            ),
            Expanded(
              child: Container(
                  child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        roundedBoxContainer(
                          margin: EdgeInsets.all(10),
                          child: TextFormField(
                            style: TextStyle(color: ColorData.nameFontColor),
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: ColorData.boxColor,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Color.fromRGBO(150, 156, 170, 1), width: 1),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.0),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: ColorData.nameFontColor, width: 1),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.0),
                                  ),
                                ),
                                labelText: "Global Class Name",
                                hintStyle: TextStyle(color: ColorData.nameFontColor),
                                labelStyle: TextStyle(color: ColorData.nameFontColor)),
                            cursorColor: ColorData.nameFontColor,
                            initialValue: project.globalClassName,
                            onFieldSubmitted: (value) {},
                            onChanged: (value) {
                              setState(() {
                                project.globalClassName = value;
                              });
                            },
                          ),
                        ),
                        roundedBoxContainer(
                          margin: EdgeInsets.all(10),
                          child: TextFormField(
                            style: TextStyle(color: ColorData.nameFontColor),
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: ColorData.boxColor,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Color.fromRGBO(150, 156, 170, 1), width: 1),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.0),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: ColorData.nameFontColor, width: 1),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.0),
                                  ),
                                ),
                                labelText: "Module Name",
                                hintStyle: TextStyle(color: ColorData.nameFontColor),
                                labelStyle: TextStyle(color: ColorData.nameFontColor)),
                            cursorColor: ColorData.nameFontColor,
                            initialValue: project.moduleName,
                            onFieldSubmitted: (value) {},
                            onChanged: (value) {
                              setState(() {
                                project.moduleName = value;
                              });
                            },
                          ),
                        ),
                        roundedBoxContainer(
                            child: SwitchListTile(
                              title: Text(
                                "C/C++ Machine BigEndian",
                                style: textStyle,
                              ),
                              activeColor: ColorData.varTypeColor,
                              value: true,
                              onChanged: (_) {},
                            ),
                            color: ColorData.boxColor,
                            margin: EdgeInsets.only(top: 10, left: 10, right: 10)),
                        roundedBoxContainer(
                            child: SwitchListTile(
                              title: Text(
                                "TypeScript Machine BigEndian",
                                style: textStyle,
                              ),
                              activeColor: ColorData.varTypeColor,
                              value: false,
                              onChanged: (_) {},
                            ),
                            color: ColorData.boxColor,
                            margin: EdgeInsets.only(top: 10, left: 10, right: 10)),
                        roundedBoxContainer(
                            child: SwitchListTile(
                              title: Text(
                                "Is C++ Code?",
                                style: textStyle,
                              ),
                              activeColor: ColorData.varTypeColor,
                              value: true,
                              onChanged: (_) {},
                            ),
                            color: ColorData.boxColor,
                            margin: EdgeInsets.only(top: 10, left: 10, right: 10)),
                        roundedBoxContainer(
                            child: SwitchListTile(
                              title: Text(
                                "Autosave",
                                style: textStyle,
                              ),
                              activeColor: ColorData.varTypeColor,
                              value: true,
                              onChanged: (_) {},
                            ),
                            color: ColorData.boxColor,
                            margin: EdgeInsets.only(top: 10, left: 10, right: 10)),
                      ],
                    ),
                  ),
                  VerticalDivider(
                    indent: size.height * 0.02,
                    endIndent: size.height * 0.02,
                    width: 0,
                    color: ColorData.nameFontColor,
                  ),
                  Expanded(
                    child: Column(),
                  )
                ],
              )),
            )
          ],
        ),
      ),
    );
  }

  Widget roundedBoxContainer({Widget child, Color color, bool hasBorder = false, TextStyle textStyle, double radius, EdgeInsets margin}) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(border: hasBorder ? Border.all() : null, color: color, borderRadius: BorderRadius.circular(10)),
      child: child,
    );
  }

  Future saveCode() async {
    if (fileManager.isOpen) {
      return await saveGeneratedCode(project.file.parent.path);
    } else {
      return await saveProject().then((value) => value == 0 ? saveGeneratedCode(project.file.parent.path) : 0);
    }
  }

  Future saveGeneratedCode(String folder) async {
    for (final board in project.boards.boardlist) {
      File file = File("$folder\\parse${board.name}.service.ts");
      final codeGen = TSCodeGenerator(moduleName: project.moduleName, globalClassName: project.globalClassName);
      await file.writeAsString(codeGen.generateCode(board));
      File filec = File("$folder\\${board.name}_${board.data.headnode.name}_generated.h");
      await filec.writeAsString(generateCCode(board.data.headnode));
    }

    File filetsd = File("$folder\\${project.moduleName}.d.ts");
    final codeGen = TSCodeGenerator(moduleName: project.moduleName, globalClassName: project.globalClassName);
    await filetsd.writeAsString(codeGen.generateTSCodeStruct(project.boards));
  }

  Future<int> saveProject() async {
    final result = await fileManager.saveProject();
    setState(() {});
    return result;
  }

  void saveProjectAs() async {
    await fileManager.saveProjectAs();
    setState(() {});
  }

  void openProject() async {
    final result = await fileManager.openProject();
    if (result < 0) return; //Error loading project
    if (project.boards.boardlist.isEmpty) {
      selectedBoard = null;
    } else {
      selectedBoard = project.boards.boardlist.first;
    }
    boardSelectorKey.currentState.selectedBoard = selectedBoard;
    setState(() {});
  }

  void newProject() {
    fileManager.newProject();
    selectedBoard = fileManager.project.boards.boardlist.first;
    boardSelectorKey?.currentState?.selectedBoard = selectedBoard;
    setState(() {});
  }

//------------------STRUCTURE TREE---------------------//

}
