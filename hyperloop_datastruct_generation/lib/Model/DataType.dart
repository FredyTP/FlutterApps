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

  DataType._(this.type, this.size, this.parseFunc);

  /*static List<DataType> dataTypes() {
    return dataTypeList;
  }*/
  static DataType uint8() {
    return DataType._("uint8_t", 1, "getUint8");
  }

  static DataType uint16() {
    return DataType._("uint16_t", 2, "getUint16");
  }

  static DataType uint32() {
    return DataType._("uint32_t", 4, "getUint32");
  }

  static DataType int8() {
    return DataType._("int8_t", 1, "getInt8");
  }

  static DataType int16() {
    return DataType._("int16_t", 2, "getInt16");
  }

  static DataType int32() {
    return DataType._("int32_t", 4, "getInt32");
  }

  static DataType float() {
    return DataType._("float", 4, "getFloat32");
  }

  static DataType float64() {
    return DataType._("double", 8, "getFloat64");
  }

  static DataType struct() {
    return DataType._("struct", 0, "parseStruct¿?");
  }

  static DataType enumeration() {
    return DataType._("enum", 1, DataType.uint8().parseFunc);
  }

  Map<String, dynamic> toMap() {
    return {"type": type, "size": size, "parseFunc": parseFunc};
  }

  factory DataType.fromMap(Map<String, dynamic> map) {
    return DataType._(map["type"], map["size"], map["parseFunc"] ?? "");
  }
  static final List<DataType> dataTypes = [
    DataType.uint8(),
    DataType.uint16(),
    DataType.uint32(),
    DataType.int8(),
    DataType.int16(),
    DataType.int32(),
    DataType.float(),
    DataType.float64(),
    DataType.struct(),
    DataType.enumeration(),
  ];
}
