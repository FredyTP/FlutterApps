import 'dart:io';
import 'dart:convert';

import 'package:hyperloop_datastruct_generation/Model/Boards.dart';

class ProjectModel {
  File file;
  Boards boards;

  ProjectModel.empty() {
    boards = Boards();
  }
  Map<String, dynamic> toMap() {
    return {"boards": boards.toMap()};
  }

  String toJson() {
    return jsonEncode(this.toMap());
  }

  void loadFromJson(String json) {
    final map = jsonDecode(json);
    boards.loadFromMap(map["boards"]);
  }
}
