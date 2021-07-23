import 'dart:io';
import 'dart:convert';

import 'package:hyperloop_datastruct_generation/Model/Boards.dart';
import 'package:hyperloop_datastruct_generation/Model/variable.dart';

class ProjectModel {
  String file;
  Boards boards;
  String moduleName;
  String globalClassName;
  List<Variable> savedStructs;

  ProjectModel.empty() {
    boards = Boards();
    moduleName = "PodDataModel";
    globalClassName = "PodDataStructure";
    savedStructs = <Variable>[];
  }
  Map<String, dynamic> toMap() {
    return {
      "boards": boards.toMap(),
      "moduleName": moduleName,
      "globalClassName": globalClassName,
      "savedStructs": savedStructs.map((e) => e.toMap()).toList(),
    };
  }

  String toJson() {
    return jsonEncode(this.toMap());
  }

  void loadFromJson(String json) {
    final map = jsonDecode(json);
    moduleName = map["moduleName"] ?? "PodDataModel";
    globalClassName = map["globalClassName"] ?? "PodDataStructure";
    boards.loadFromMap(map["boards"]);
    savedStructs = map["savedStructs"]?.map((e) => Variable.fromMap(e))?.cast<Variable>()?.toList() ?? <Variable>[];
    print(moduleName);
  }
}
