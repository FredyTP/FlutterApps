//                   GNU GENERAL PUBLIC LICENSE
//                    Version 3, 29 June 2007

//Copyright (C) 2007 Free Software Foundation, Inc. <https://fsf.org/>
//Everyone is permitted to copy and distribute verbatim copies
// of this license document, but changing it is not allowed.
//Author: Alfredo Torres Pons

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
  String newMap(Variable vari) {
    if (declaredMaps.contains(vari.name)) {
      return "\n${vari.name} = new Map()\n";
    } else {
      declaredMaps.add(vari.name);
      return "\nlet ${vari.name} = new Map()\n";
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
      return '${parent.name}.set("${vari.name}",[])\n';
    } else {
      if (vari.isStruct()) {
        final ret = '${parent.name}.set("${vari.name}",0)\n';
        return ret;
      } else {
        final ret = '${parent.name}.set("${vari.name}",data.${parseFunction(vari)})\n';
        idx++;
        return ret;
      }
    }
  }

  String setMapField(Variable vari, Variable parent) {
    if (vari.isArray()) {
      if (vari.isStruct()) {
        return '${parent.name}.get("${vari.name}").push(${vari.name})\n';
      } else {
        final ret = '${parent.name}.get("${vari.name}").push(data.${parseFunction(vari)})\n';
        idx++;
        return ret;
      }
    } else {
      if (vari.isStruct()) {
        return '${parent.name}.set("${vari.name}",${vari.name})\n';
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

  String generateCode(Variable headnode) {
    //int bufferSize = Variable.countStructSizeRecursive(headnode.children, 0);
    listedVariables = recursiveGenList(headnode, []);
    print(listedVariables.length);
    for (int i = 1; i < listedVariables.length; i++) {
      listedVariables[i].index = listedVariables[i - 1].index + listedVariables[i - 1].vari.type.size;
    }
    String code = "";
    code += "let array = new Uint8Array(-INSERTAR_ARRAY-);\n";
    code += "let data=new DataView(array.buffer);\n";

    code += recursiveGenerateTScode(headnode);
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
