import 'package:YoNunca/src/app_state.dart';
import 'package:YoNunca/src/models/frase_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PendingFrasesPage extends StatefulWidget {
  PendingFrasesPage({Key key}) : super(key: key);

  @override
  _PendingFrasesPageState createState() => _PendingFrasesPageState();
}

class _PendingFrasesPageState extends State<PendingFrasesPage> {
  @override
  Widget build(BuildContext context) {
    final bloc = AppStateContainer.of(context).blocProvider.fraseBloc;
    return Scaffold(
      appBar: AppBar(
        title: Text("Frases pendientes de aceptar"),
      ),
      body: Container(
        child: StreamBuilder(
          stream: bloc.pendingFrasesReferences,
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              return ListView.separated(
                separatorBuilder: (context, index) => Divider(
                  indent: 15,
                  endIndent: 15,
                ),
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  final doc = snapshot.data.documents[index];
                  final frase = FraseModel.fromJson(doc.data);
                  return Dismissible(
                    key: ValueKey(doc.documentID),
                    onDismissed: (direction) {
                      if (direction == DismissDirection.startToEnd) {
                        bloc.acceptFrase(doc.reference);
                      } else {
                        bloc.deleteFrase(doc.reference);
                      }
                    },
                    direction: DismissDirection.horizontal,
                    background: Container(
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Icon(
                              Icons.check,
                              size: 30,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 5),
                            child: VerticalDivider(),
                          )
                        ],
                      ),
                      color: Colors.green,
                    ),
                    secondaryBackground: Container(
                      color: Colors.red,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 5),
                            child: VerticalDivider(),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Icon(
                              Icons.delete_forever,
                              size: 30,
                            ),
                          ),
                        ],
                      ),
                    ),
                    child: ListTile(
                      title: Text(frase.frase),
                      subtitle: Text(frase.uid),
                    ),
                  );
                },
              );
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
