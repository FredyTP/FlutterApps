//                   GNU GENERAL PUBLIC LICENSE
//                    Version 3, 29 June 2007

//Copyright (C) 2007 Free Software Foundation, Inc. <https://fsf.org/>
//Everyone is permitted to copy and distribute verbatim copies
// of this license document, but changing it is not allowed.
//Author: Alfredo Torres Pons

import 'package:hyperloop_datastruct_generation/Model/variable.dart';

class VariableInfo {
  Variable vari;
  int index;
  List<int> arrayIdx;
  VariableInfo(this.vari, this.index, this.arrayIdx);
}
