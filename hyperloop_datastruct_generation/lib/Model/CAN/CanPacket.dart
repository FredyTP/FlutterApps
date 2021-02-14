import 'package:hyperloop_datastruct_generation/Model/CAN/CanVariable.dart';

class CanPacket {
  final int maxlen = 8;

  int id;
  String idMacro;

  int len;

  List<CanVariable> varList = List<CanVariable>.empty(growable: true);

  CanPacket();
  CanPacket.manual({this.id, this.idMacro, this.len, this.varList});

  bool addVariable(CanVariable vari) {
    if (vari.transDataType.size + len > maxlen) {
      return false;
    } else {
      varList.add(vari);
      len += vari.transDataType.size;
      return true;
    }
  }
}
