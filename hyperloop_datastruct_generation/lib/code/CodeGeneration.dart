//                   GNU GENERAL PUBLIC LICENSE
//                    Version 3, 29 June 2007

//Copyright (C) 2007 Free Software Foundation, Inc. <https://fsf.org/>
//Everyone is permitted to copy and distribute verbatim copies
// of this license document, but changing it is not allowed.
//Author: Alfredo Torres Pons

import 'package:hyperloop_datastruct_generation/Model/BoardModel.dart';
import 'package:hyperloop_datastruct_generation/Model/Boards.dart';
import 'package:hyperloop_datastruct_generation/Model/VariableInfo.dart';
import 'package:hyperloop_datastruct_generation/Model/variable.dart';

String recursiveGenerateCCode(List<Variable> varlist, Variable struct) {
  String code = "";
  for (Variable vari in varlist) {
    if (vari.type.type == "struct") {
      code += recursiveGenerateCCode(vari.children, vari);
    }
  }
  code += "struct ${struct.structType} \n{";
  for (Variable vari in varlist) {
    code += "\n";
    String varname = vari.name;
    if (vari.arrayLen > 1) {
      varname += "[${vari.arrayLen}]";
    }
    if (vari.isStruct()) {
      code += ("\tstruct " + vari.structType + " " + varname + ";");
    } else if (vari.isEnum()) {
      code += ("\tenum " + vari.enumName + " " + varname + ";");
    } else {
      code += ("\t" + vari.type.type + " " + varname + ";");
    }
  }
  code += "\n};\n\n";
  return code;
}

String generateCCode(Variable headnode) {
  String header = "#ifndef ${headnode.name.toUpperCase()}_GENERATED_H_\n#define ${headnode.name.toUpperCase()}_GENERATED_H_\n \n#pragma pack(1)\n \n#include<stdint.h> \n \n";
  String code = header + recursiveGenerateCCode(headnode.children, headnode);
  int bufferSize = Variable.countStructSizeRecursive(headnode.children, 0);
  code += "\n";
  code += "union ${headnode.structType}" + "union";
  code += "{\n";
  code += "\tstruct ${headnode.structType} ${headnode.name.toLowerCase()};\n";
  code += "\tuint8_t buffer[$bufferSize];\n";
  code += "};";
  code += "\n";
  code += "#endif //${headnode.name.toUpperCase()}_GENERATED_H_";
  return code;
}

class TSCodeGenerator {
  List<VariableInfo> listedVariables;
  List<String> declaredMaps = [];
  int idx = 0;
  final String moduleName;
  final String globalClassName;

  TSCodeGenerator({this.moduleName, this.globalClassName});

  String newMap(Variable vari) {
    if (declaredMaps.contains(vari.name)) {
      return "\n";
    } else {
      declaredMaps.add(vari.name);
      return "\n\tconst ${vari.name}: $moduleName.${vari.structType} = <$moduleName.${vari.structType}>{};\n";
    }
  }

  String parseFunction(Variable vari) {
    if (vari.type.size > 1) {
      return vari.type.parseFunc + "(${listedVariables[idx].index},true)";
    }
    return vari.type.parseFunc + "(${listedVariables[idx].index})";
  }

  String addMapFieldTo(Variable vari, Variable parent) {
    if (vari.isArray()) {
      return '\t${parent.name}.${vari.name}=[];\n';
    } else {
      if (vari.isStruct()) {
        //final ret = '${parent.name}.set("${vari.name}",0)\n';
        final ret = "";
        return ret;
      } else {
        final ret = '\t${parent.name}.${vari.name}=data.${parseFunction(vari)};\n';
        idx++;
        return ret;
      }
    }
  }

  String setMapField(Variable vari, Variable parent) {
    if (vari.isArray()) {
      if (vari.isStruct()) {
        return '\t${parent.name}.${vari.name}.push(${vari.name});\n';
      } else {
        final ret = '\t${parent.name}.${vari.name}.push(data.${parseFunction(vari)});\n';
        idx++;
        return ret;
      }
    } else {
      if (vari.isStruct()) {
        return '\t${parent.name}.${vari.name}=${vari.name};\n';
      }

      return "";
    }
  }

  String recursiveGenerateTScode(Variable vari) {
    String code = "";

    if (vari.isStruct()) {
      code += newMap(vari);
      vari.children.forEach((element) {
        code += addMapFieldTo(element, vari);
        for (int i = 0; i < element.arrayLen; i++) {
          code += recursiveGenerateTScode(element);
          code += setMapField(element, vari);
        }
      });
    }

    return code;
  }

  String generateCode(BoardModel board) {
    //int bufferSize = Variable.countStructSizeRecursive(headnode.children, 0);
    final headnode = board.data.headnode;
    listedVariables = recursiveGenList(headnode, []);
    print(listedVariables.length);
    for (int i = 1; i < listedVariables.length; i++) {
      listedVariables[i].index = listedVariables[i - 1].index + listedVariables[i - 1].vari.type.size;
    }
    String code = "";
    code += "parse${board.name}(data): $moduleName.${headnode.structType}{\n";
    code += recursiveGenerateTScode(headnode);
    code += "\n\treturn ${headnode.name};";
    code += "\n}";
    return code;
  }

//TS STRUCT CODE GENERATION (EASY)
  String recursiveGenerateTSCodeStruct(List<Variable> varlist, Variable struct) {
    String code = "";
    for (Variable vari in varlist) {
      if (vari.type.type == "struct") {
        code += recursiveGenerateTSCodeStruct(vari.children, vari);
      }
    }
    code += "\texport interface ${struct.structType} \n\t{";
    for (Variable vari in varlist) {
      code += "\n";
      String varType = "number";
      if (vari.isStruct()) {
        varType = vari.structType;
      }
      if (vari.arrayLen > 1) {
        varType = "$varType[]";
      }
      if (vari.isStruct()) {
        code += ("\t\t" + vari.name + ": " + varType + ";");
      } else if (vari.isEnum()) {
        code += ("\t\tenum " + vari.enumName + " " + varType + ";"); //NOT OK CORRECT IF NECESARY
      } else {
        code += ("\t\t" + vari.name + ": " + varType + ";");
      }
    }
    code += "\n\t}\n\n";
    return code;
  }

  String generateTSCodeStruct(Boards boards) {
    //String header = "#ifndef ${headnode.name.toUpperCase()}_GENERATED_H_\n#define ${headnode.name.toUpperCase()}_GENERATED_H_\n \n#pragma pack(1)\n \n#include<stdint.h> \n \n";
    String code = "export declare module $moduleName \n{\n";
    for (final board in boards.boardlist) {
      code += recursiveGenerateTSCodeStruct(board.data.headnode.children, board.data.headnode);
    }
    code += "\n\texport interface $globalClassName \n\t{";
    for (final BoardModel board in boards.boardlist) {
      code += "\n\t\t${board.data.headnode.name}: ${board.data.headnode.structType};";
    }
    code += "\n\t}";

    code += "\n}";

    return code;
  }
}

List<VariableInfo> recursiveGenList(Variable node, List<int> index) {
  List<VariableInfo> varlist = [];
  for (Variable vari in node.children) {
    if (vari.isStruct()) {
      if (vari.arrayLen > 1) index.add(0);
      for (int i = 0; i < vari.arrayLen; i++) {
        if (vari.arrayLen > 1) index.last = i;
        varlist.addAll(recursiveGenList(vari, index));
      }
      if (vari.arrayLen > 1) index.removeLast();
    } else {
      for (int i = 0; i < vari.arrayLen; i++) {
        final toadd = VariableInfo(vari, 0, [...index, i]); //VariableInfo(Variable(arrayLen: vari.arrayLen, name: vari.name + "-${index.join(':')}:${vari.arrayLen > 1 ? i : ""}", type: vari.type), 0, index);
        varlist.add(toadd);
      }
    }
  }
  return varlist;
}
