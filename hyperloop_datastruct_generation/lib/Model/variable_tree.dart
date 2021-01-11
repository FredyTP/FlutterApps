//                   GNU GENERAL PUBLIC LICENSE
//                    Version 3, 29 June 2007

//Copyright (C) 2007 Free Software Foundation, Inc. <https://fsf.org/>
//Everyone is permitted to copy and distribute verbatim copies
// of this license document, but changing it is not allowed.
//Author: Alfredo Torres Pons

import 'package:hyperloop_datastruct_generation/Model/variable.dart';

import 'DataType.dart';

class VariableTree {
  List<Variable> varlist;

  Variable get headnode => varlist[0];

  VariableTree() {
    varlist = [
      Variable(
        type: DataType.struct(),
        name: "DataStruct",
        structType: "BaseDataStruct",
        children: List<Variable>.empty(growable: true),
      )
    ];
  }

  int size() {
    return Variable.countStructSizeRecursive(varlist, 0);
  }

  int maxDepth() {
    return Variable.maxDepth(varlist, 0);
  }

  int numVariables() {
    return Variable.numVariables(varlist, 0);
  }

  void loadJson(String json) {
    varlist[0] = Variable.fromJson(json);
  }

  String toJson() {
    return headnode.toJson();
  }

  factory VariableTree.fromMap(Map<String, dynamic> map) {
    final tree = VariableTree();
    tree.varlist[0] = Variable.fromMap(map);
    return tree;
  }
  Map<String, dynamic> toMap() {
    return headnode.toMap();
  }

  void addVariable(Variable parent, Variable child) {
    parent.children.add(child);
  }

  void deleteVariable(Variable vari) {
    vari.type = null;
    _deleteNullVariable(varlist);
  }

  static void _deleteNullVariable(List<Variable> varlist) {
    varlist.removeWhere((element) => element.type == null);
    varlist.forEach((element) {
      if (element.isStruct()) _deleteNullVariable(element.children);
    });
  }
}
