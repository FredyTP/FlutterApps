import 'package:YoNunca/src/app_state.dart';
import 'package:YoNunca/src/models/frase_model.dart';
import 'package:flutter/material.dart';

class YoNuncaListTile extends StatelessWidget {
  final FraseModel yoNunca;
  final bool canEdit;
  const YoNuncaListTile({Key key, @required this.yoNunca, this.canEdit = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final good = Colors.green;
    final bad = Colors.red;
    final color = Color.lerp(bad, good, yoNunca.rating / 10);
    return ListTile(
      onLongPress: canEdit ? () => _popUpMenuDestroyer(context) : null,
      title: Container(
        child: Text(yoNunca.frase),
      ),
      subtitle: Text("Votos: ${yoNunca.votes}"),
      leading: Container(
        child: Text(
          yoNunca.rating.toStringAsPrecision(3),
          style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 17),
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide(width: 10, color: Colors.white)),
    );
  }

  _popUpMenuDestroyer(BuildContext context) async {
    final bloc = AppStateContainer.of(context).blocProvider.fraseBloc;
    final popUpMenu = AlertDialog(
      title: Text("Borrar Yo Nunca"),
      content: Text("Desea Eliminar el Yo Nunca: ${yoNunca.frase}"),
      actions: [
        FlatButton.icon(
          onPressed: () {
            bloc.deleteFraseFromData(yoNunca);
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.delete),
          label: Text("Eliminar"),
          color: Colors.red,
        ),
      ],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 20,
    );
    showDialog(
      context: context,
      builder: (context) {
        return popUpMenu;
      },
    );
  }
}
