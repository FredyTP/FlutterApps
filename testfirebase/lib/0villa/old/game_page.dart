import 'dart:math';

import 'package:flutter/material.dart';
import 'package:testfirebase/0villa/bloc/frase_bloc.dart';
import 'package:testfirebase/0villa/models/frase_model.dart';

class GamePage extends StatefulWidget {
  GamePage({Key key}) : super(key: key);

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  int numFrase = 0;
  bool first = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<List<FraseModel>>(
            stream: FraseBloc.frasesStream,
            builder: (context, snapshot) {
              if (snapshot.hasData == false) {
                return Center(child: Container(width: MediaQuery.of(context).size.width * 0.8, child: LinearProgressIndicator()));
              }
              if (first) {
                first = false;
                numFrase = Random().nextInt(snapshot.data.length);
              }
              return Container(
                padding: EdgeInsets.all(50),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Yo nunca",
                        textScaleFactor: 3,
                      ),
                      SizedBox(
                        height: 30,
                        width: double.infinity,
                      ),
                      Container(child: Text(snapshot.data[numFrase].frase)),
                      SizedBox(
                        height: 30,
                        width: double.infinity,
                      ),
                      RaisedButton(
                        onPressed: () {
                          setState(() {
                            numFrase = Random().nextInt(snapshot.data.length);
                          });
                        },
                        child: Text(
                          "Next",
                          textScaleFactor: 1.5,
                        ),
                      )
                    ],
                  ),
                ),
              );
            }));
  }
}
