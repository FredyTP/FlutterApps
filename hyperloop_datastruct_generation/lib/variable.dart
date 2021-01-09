//                   GNU GENERAL PUBLIC LICENSE
//                    Version 3, 29 June 2007

//Copyright (C) 2007 Free Software Foundation, Inc. <https://fsf.org/>
//Everyone is permitted to copy and distribute verbatim copies
// of this license document, but changing it is not allowed.
//Author: Alfredo Torres Pons

import 'dart:convert';
import 'dart:math';

import 'package:hyperloop_datastruct_generation/DataType.dart';

class Variable {
  DataType type;
  String name;
  String structType;
  int arrayLen;
  bool hide;
  bool selected;
  List<Variable> children = List<Variable>.empty(growable: true);

  Variable({this.type, this.name, this.children, this.structType = "", this.arrayLen = 1, this.hide = false, this.selected = true});

  Map<String, dynamic> toMap() {
    return {"type": type.toMap(), "name": name, "structType": structType, "arrayLen": arrayLen, "selected": selected, "hide": hide, "children": children.map((e) => e.toMap()).toList()};
  }

  factory Variable.fromMap(Map<String, dynamic> map) {
    return Variable(type: DataType.fromMap(map["type"]), name: map["name"], structType: map["structType"], arrayLen: map["arrayLen"], selected: map["selected"] ?? true, hide: map["hide"] ?? false, children: map["children"].map((e) => Variable.fromMap(e)).toList().cast<Variable>());
  }

  String toJson() {
    return jsonEncode(this.toMap());
  }

  factory Variable.fromJson(String json) {
    return Variable.fromMap(jsonDecode(json));
  }

  bool isStruct() {
    return type.type == "struct";
  }

  bool isArray() {
    return arrayLen > 1;
  }

  static int countStructSizeRecursive(List<Variable> varlist, int cont) {
    int count = cont;
    for (Variable vari in varlist) {
      if (vari.type.type == "struct") {
        count += vari.arrayLen * countStructSizeRecursive(vari.children, cont);
      } else {
        count += vari.type.size * vari.arrayLen;
      }
    }

    return count;
  }

  static int maxDepth(List<Variable> varlist, int cont) {
    int dep = cont;
    for (Variable vari in varlist) {
      if (vari.type.type == "struct") {
        dep = max(dep, maxDepth(vari.children, cont + 1));
      }
    }
    return dep;
  }

  static int numVariables(List<Variable> varlist, int cont) {
    int nvars = cont;
    for (Variable vari in varlist) {
      if (vari.isStruct()) {
        nvars += numVariables(vari.children, 0);
      } else {
        nvars++;
      }
    }
    return nvars;
  }
}
