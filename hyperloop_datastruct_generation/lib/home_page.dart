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
import 'package:hyperloop_datastruct_generation/Model/BoardModel.dart';

import 'package:hyperloop_datastruct_generation/Model/DataType.dart';
import 'package:hyperloop_datastruct_generation/Model/variable.dart';
import 'package:hyperloop_datastruct_generation/Model/variable_tree.dart';
import 'package:hyperloop_datastruct_generation/data_struct_editor.dart';

import 'Model/Boards.dart';
import 'board_selector.dart';
import 'code/CodeGeneration.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Boards boards = Boards(boardlist: [BoardModel(name: "MASTER")]);
  BoardModel selectedBoard;
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
    selectedBoard = boards.boardlist.first;
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
        actions: appBarActions(),
      ),
      body: Row(
        children: [
          AnimatedContainer(
            width: showBoards ? 200 : 0,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOutSine,
            child: BoardSelector(
              boards: boards,
              selectBoard: this.selectBoard,
            ),
          ),
          Expanded(
            flex: 3,
            child: DataStructEditor(
              variableTree: selectedBoard.data,
            ),
          ),
        ],
      ),
    );
  }

//-----------STRUCTURE USEFUL INFORMATION-----------//

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
    File file = File("${selectedBoard.data.headnode.name}_generated.js");
    final codeGen = TSCodeGenerator();
    await file.writeAsString(codeGen.generateCode(selectedBoard.data.headnode));
    File filec = File("${selectedBoard.data.headnode.name}_generated.h");
    await filec.writeAsString(generateCCode(selectedBoard.data.headnode));
  }

  void saveDataStructure() async {
    var saveFile = SaveFilePicker();
    saveFile.filterSpecification = {"HLDataStructure": "*.hlds"};
    saveFile.defaultExtension = "hlds";
    var result = saveFile.getFile();
    if (result != null) await result.writeAsString(selectedBoard.data.toJson());
  }

  void loadDataStructure() async {
    var openFile = OpenFilePicker();
    openFile.filterSpecification = {"HLDataStructure": "*.hlds"};
    openFile.defaultExtension = "hlds";
    var result = openFile.getFile();
    if (result != null) selectedBoard.data.loadJson(await result.readAsString());
    setState(() {});
  }

//------------------STRUCTURE TREE---------------------//

}
