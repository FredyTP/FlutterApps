//                   GNU GENERAL PUBLIC LICENSE
//                    Version 3, 29 June 2007

//Copyright (C) 2007 Free Software Foundation, Inc. <https://fsf.org/>
//Everyone is permitted to copy and distribute verbatim copies
// of this license document, but changing it is not allowed.
//Author: Alfredo Torres Pons

class DataType {
  final String type;
  final String parseFunc;
  final int size;
  DataType(this.type, this.size, this.parseFunc);

  /*static List<DataType> dataTypes() {
    return dataTypeList;
  }*/

  static DataType float() {
    return DataType("float", 4, "getFloat32");
  }

  Map<String, dynamic> toMap() {
    return {"type": type, "size": size, "parseFunc": parseFunc};
  }

  factory DataType.fromMap(Map<String, dynamic> map) {
    return DataType(map["type"], map["size"], map["parseFunc"] ?? "");
  }
}
