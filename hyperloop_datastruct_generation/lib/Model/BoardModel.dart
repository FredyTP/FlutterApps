import 'package:hyperloop_datastruct_generation/Model/variable_tree.dart';

class BoardModel {
  String name;
  VariableTree data = VariableTree();

  BoardModel({this.name, this.data}) {
    if (this.data == null) {
      this.data = VariableTree();
    }
  }

  Map<String, dynamic> toMap() {
    return {"name": this.name, "data": this.data.toMap()};
  }

  factory BoardModel.fromMap(Map<String, dynamic> map) {
    return BoardModel(name: map["name"], data: VariableTree.fromMap(map["data"]));
  }
}
