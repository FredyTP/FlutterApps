import 'dart:math';

import 'package:YoNunca/src/app_state.dart';
import 'package:YoNunca/src/bloc/frase_bloc.dart';
import 'package:YoNunca/src/models/frase_model.dart';
import 'package:YoNunca/src/widgets/vote_frase_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

//todo: adaptar a pantallas pequeñas:)
class GamePage extends StatefulWidget {
  GamePage({Key key}) : super(key: key);

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  int numFrase = 0;
  bool first = true;

  final _voteKey = GlobalKey<VoteFraseWidgetState>();

  @override
  Widget build(BuildContext context) {
    final frasesBloc = AppStateContainer.of(context).blocProvider.fraseBloc;
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Modo Aleatorio")),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              AppStateContainer.of(context).blocProvider.appUserBloc.signOut();
            },
          )
        ],
      ),
      body: StreamBuilder<List<DocumentSnapshot>>(
        stream: frasesBloc.frasesStreamDocuments(pending: false),
        builder: (context, snapshot) {
          if (snapshot.hasData == false) {
            return Center(child: Container(width: MediaQuery.of(context).size.width * 0.8, child: LinearProgressIndicator()));
          }
          if (first) {
            first = false;
            print(snapshot.data.length);
            numFrase = Random().nextInt(snapshot.data.length);
          }
          final document = snapshot.data[numFrase];
          final frase = FraseModel.fromJson(document.data);
          return Container(
            color: Color.fromRGBO(250, 192, 233, 1),
            padding: EdgeInsets.all(20),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "Yo nunca",
                        textScaleFactor: 4,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Image.asset(
                        "assets/villa_icon.png",
                        width: MediaQuery.of(context).size.width / 4.5,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 30,
                    width: double.infinity,
                  ),
                  Expanded(
                    child: Card(
                      clipBehavior: Clip.hardEdge,
                      child: Container(
                        color: Colors.grey[400],
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                            child: Text(
                              frase.frase,
                              style: TextStyle(fontSize: 30, color: Colors.black),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                    width: double.infinity,
                  ),
                  VoteFraseWidget(key: _voteKey, yoNunca: document),
                  SizedBox(
                    height: 20,
                    width: double.infinity,
                  ),
                  RaisedButton(
                    onPressed: () {
                      setState(() {
                        _voteKey.currentState.resetVote();
                        numFrase = Random().nextInt(snapshot.data.length);
                      });
                    },
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: Text(
                      "Next",
                      textScaleFactor: 3,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                    width: double.infinity,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
