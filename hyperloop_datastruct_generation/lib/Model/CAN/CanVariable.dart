import 'dart:convert';

import 'package:hyperloop_datastruct_generation/Model/DataType.dart';

class CanVariable {
  String name;

  DataType boardDataType;
  DataType transDataType;

  double offset;
  double scale;

  bool isStruct;
  List<CanVariable> children = List<CanVariable>.empty(growable: true);

  CanVariable({this.name, this.boardDataType, this.transDataType, this.offset = 0, this.scale = 1, this.isStruct = false});
  Map<String, dynamic> toMap() {
    return {"name": this.name, "boardDataType": this.boardDataType, "transDataType": this.transDataType, "offset": this.offset, "scale": this.scale};
  }

  String toJson() {
    return jsonEncode(this.toMap());
  }
}
