import 'package:filepicker_windows/filepicker_windows.dart';
import 'package:hyperloop_datastruct_generation/Model/BoardModel.dart';
import 'package:hyperloop_datastruct_generation/Model/Boards.dart';

class FileManager {
  final void Function() onLoadData;
  FileManager({this.onLoadData});

  Future<void> loadFile(Boards boards) async {
    var openFile = OpenFilePicker();
    openFile.filterSpecification = {"HLBoards": "*.hlb"};
    openFile.defaultExtension = "hl";
    var result = openFile.getFile();
    if (result != null) boards.loadFromJson(await result.readAsString());
    onLoadData?.call();
    //selectedBoard = boards.boardlist.first;
    //boardSelectorKey.currentState.selectedBoard = selectedBoard;
    //setState(() {});
  }

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
