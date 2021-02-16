import 'dart:io';

import 'package:filepicker_windows/filepicker_windows.dart';
import 'package:hyperloop_datastruct_generation/Model/BoardModel.dart';
import 'package:hyperloop_datastruct_generation/Model/Boards.dart';
import 'package:hyperloop_datastruct_generation/Model/project_model.dart';

class FileManager {
  final void Function() onLoadData;
  final ProjectModel project;
  FileManager({this.project, this.onLoadData});

  bool get isOpen => project.file != null;

//Opens existing project and loads the data
  Future<int> openProject() async {
    final result = _getOpenProjectFile();
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

  Future<int> _readProjectData(File file) async {
    ProjectModel temp = ProjectModel.empty();
    temp.loadFromJson(await file.readAsString());
    if (temp.boards.boardlist == null) {
      return -1; //Bad File Format
    }
    project.boards = temp.boards;
    project.file = file;
    project.globalClassName = temp.globalClassName;
    project.moduleName = temp.moduleName;
    return 0;
  }

  File _getOpenProjectFile() {
    var openFile = OpenFilePicker();
    openFile.filterSpecification = {"HLProject": "*.hlpj"};
    openFile.defaultExtension = "hlpj";
    return openFile.getFile();
  }

  File _getSaveProjectFile() {
    var saveFile = SaveFilePicker();
    saveFile.filterSpecification = {"HLProject": "*.hlpj"};
    saveFile.defaultExtension = "hlpj";
    return saveFile.getFile();
  }

  void newProject() {
    project.boards = Boards(boardlist: [BoardModel(name: "MASTER")]);
    project.file = null;
    project.moduleName = "PodDataModel";
    project.globalClassName = "PodDataStructure";
  }

//Saves actual project into its file, if new project save file as
  Future<int> saveProject() async {
    if (this.isOpen) {
      await _saveProjectData(project.file);
      onLoadData?.call();
      return 0;
    } else {
      return await saveProjectAs();
    }
  }

//Saves project as new project in new file
  Future<int> saveProjectAs() async {
    final file = _getSaveProjectFile();
    if (file != null) {
      project.file = await _saveProjectData(file);
      onLoadData?.call();
      return 0;
    }
    return -1;
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
    var saveFile = SaveFilePicker();
    saveFile.filterSpecification = {"HLBoards": "*.hlb"};
    saveFile.defaultExtension = "hl";
    var result = saveFile.getFile();
    if (result != null) await result.writeAsString(boards.toJson());
  }

  Future<void> exportDataStructure(BoardModel selectedBoard) async {
    var saveFile = SaveFilePicker();
    saveFile.filterSpecification = {"HLDataStructure": "*.hlds"};
    saveFile.defaultExtension = "hlds";
    var result = saveFile.getFile();
    if (result != null) await result.writeAsString(selectedBoard.data.toJson());
  }

  Future<void> importDataStructure(BoardModel selectedBoard) async {
    var openFile = OpenFilePicker();
    openFile.filterSpecification = {"HLDataStructure": "*.hlds"};
    openFile.defaultExtension = "hlds";
    var result = openFile.getFile();
    if (result != null) selectedBoard.data.loadJson(await result.readAsString());
    onLoadData?.call();
  }
}
