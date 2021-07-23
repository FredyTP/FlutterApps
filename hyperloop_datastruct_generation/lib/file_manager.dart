import 'dart:io';
import 'dart:convert';
import 'dart:html' as html;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hyperloop_datastruct_generation/Model/BoardModel.dart';
import 'package:hyperloop_datastruct_generation/Model/Boards.dart';
import 'package:hyperloop_datastruct_generation/Model/project_model.dart';
import 'package:hyperloop_datastruct_generation/color_data.dart';

class FileManager {
  final void Function() onLoadData;
  final ProjectModel project;
  FileManager({this.project, this.onLoadData});

  bool get isOpen => project.file != null;

//Opens existing project and loads the data
  Future<int> openProject() async {
    final result = await _getOpenProjectFile();
    if (result == null) {
      return -1; //No file selected
    }
    if (await _readProjectData(result) < 0) {
      return -2;
    }

    onLoadData?.call();
    return 0;
  }

  Future<File> _saveProjectData(File file) async {
    return await file.writeAsString(project.toJson());
  }

  Future<int> _readProjectData(PlatformFile file) async {
    ProjectModel temp = ProjectModel.empty();
    temp.loadFromJson(String.fromCharCodes(file.bytes));
    if (temp.boards.boardlist == null) {
      return -1; //Bad File Format
    }
    project.loadFromJson(temp.toJson());
    project.file = file.name;
    return 0;
  }

  Future<PlatformFile> _getOpenProjectFile() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(type: FileType.custom, allowMultiple: false, allowedExtensions: ["hlpj"]);
    return result.files[0];
  }

  //Future<File> _getSaveProjectFile() async {
  //String result = await FilePicker.platform.getDirectoryPath();
  //return File(result + "/defaul_name.hlpj");
  // }

  void newProject() {
    project.boards = Boards(boardlist: [BoardModel(name: "MASTER")]);
    project.file = null;
    project.moduleName = "PodDataModel";
    project.globalClassName = "PodDataStructure";
  }

  Future saveFileHTML(String filename, String data) async {
    final text = data;

// prepare
    final bytes = utf8.encode(text);
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = filename;
    html.document.body.children.add(anchor);

// download
    anchor.click();

// cleanup
    html.document.body.children.remove(anchor);
    html.Url.revokeObjectUrl(url);
  }

//Saves actual project into its file, if new project save file as
  Future<int> saveProject(BuildContext context) async {
    if (this.isOpen) {
      await saveFileHTML(project.file, project.toJson());
      onLoadData?.call();
      return 0;
    } else {
      return await saveProjectAs(context);
    }
  }

//Saves project as new project in new file
  Future<int> saveProjectAs(BuildContext context) async {
    final projectname = await nameDialog(context);
    if (projectname == null) {
      return -1;
    }
    project.file = projectname + ".hlpj";
    saveProject(context);
    //final file = _getSaveProjectFile();
    //if (file != null) {
    //project.file = await _saveProjectData(await file);
    onLoadData?.call();
    return 0;
    //}
  }

  Future<String> nameDialog(BuildContext context) async {
    String projectname;
    final what = await showDialog<bool>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: ColorData.bgColor,
              title: Text(
                "Set the Project Name",
                style: TextStyle(color: ColorData.nameFontColor),
              ),
              content: TextFormField(
                style: TextStyle(color: ColorData.nameFontColor),
                decoration: InputDecoration(
                    filled: true,
                    //fillColor: color,
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
                    hintText: "ProjectName",
                    hintStyle: TextStyle(color: Color.fromRGBO(150, 156, 170, 1)),
                    labelStyle: TextStyle(color: ColorData.nameFontColor)),
                cursorColor: ColorData.nameFontColor,
                onChanged: (value) => setState(() => projectname = value),
              ),
              actions: <Widget>[
                RaisedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text("OK"),
                  color: Colors.green,
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(
                    "Cancel",
                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
    if (what == true) {
      return projectname;
    }
    return null;
  }

  void loadProjectData() {}
  /*
  Future<void> loadFile() async {
    var openFile = OpenFilePicker();
    openFile.filterSpecification = {"HLBoards": "*.hlb"};
    openFile.defaultExtension = "hl";
    var result = openFile.getFile();
    if (result != null) boards.loadFromJson(await result.readAsString());
    onLoadData?.call();
    //selectedBoard = boards.boardlist.first;
    //boardSelectorKey.currentState.selectedBoard = selectedBoard;
    //setState(() {});
  }*/

  Future<void> saveFile(Boards boards) async {
    var saveFile = null; //SaveFilePicker();
    saveFile.filterSpecification = {"HLBoards": "*.hlb"};
    saveFile.defaultExtension = "hl";
    var result = saveFile.getFile();
    if (result != null) await result.writeAsString(boards.toJson());
  }

  Future<void> exportDataStructure(BoardModel selectedBoard) async {
    String saveFile = selectedBoard.name + ".hlds"; //SaveFilePicker();
    saveFileHTML(saveFile, selectedBoard.data.toJson());
  }

  Future<void> importDataStructure(BoardModel selectedBoard) async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false, allowedExtensions: ["hlds"], type: FileType.custom);
    if (result != null) selectedBoard.data.loadJson(String.fromCharCodes(result.files[0].bytes));
    onLoadData?.call();
  }
}
