import 'dart:io';
import 'dart:convert';

import 'package:hyperloop_datastruct_generation/Model/Boards.dart';

class ProjectModel {
  File file;
  Boards boards;
  String moduleName;
  String globalClassName;

  ProjectModel.empty() {
    boards = Boards();
    moduleName = "PodDataModel";
    globalClassName = "PodDataStructure";
  }
  Map<String, dynamic> toMap() {
    return {
      "boards": boards.toMap(),
      "moduleName": moduleName,
      "globalClassName": globalClassName,
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
    print(moduleName);
  }
}
