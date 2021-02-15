import 'dart:convert';

import 'package:hyperloop_datastruct_generation/Model/BoardModel.dart';

class Boards {
  List<BoardModel> boardlist;

  Boards({this.boardlist = const <BoardModel>[]});

  void add(BoardModel model) {
    boardlist.add(model);
  }

  void remove(BoardModel model) {
    boardlist.remove(model);
  }

  Map<String, dynamic> toMap() {
    return {"boardlist": boardlist.map((e) => e.toMap()).toList()};
  }

  String toJson() {
    return jsonEncode(this.toMap());
  }

  factory Boards.fromMap(Map<String, dynamic> map) {
    return Boards(boardlist: map["boardlist"].map((e) => BoardModel.fromMap(e)).toList().cast<BoardModel>());
  }
  void loadFromJson(String json) {
    final map = jsonDecode(json);
    this.loadFromMap(map);
  }

  void loadFromMap(Map<String, dynamic> map) {
    this.boardlist = map["boardlist"]?.map((e) => BoardModel.fromMap(e))?.toList()?.cast<BoardModel>();
  }
}
