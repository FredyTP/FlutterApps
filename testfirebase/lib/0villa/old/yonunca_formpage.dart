import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:testfirebase/0villa/bloc/frase_bloc.dart';

class YoNuncaFormPage extends StatefulWidget {
  YoNuncaFormPage({Key key}) : super(key: key);

  @override
  _YoNuncaFormPageState createState() => _YoNuncaFormPageState();
}

class _YoNuncaFormPageState extends State<YoNuncaFormPage> {
  String frase;
  int numero;
  String errorFrase;
  final collection = Firestore.instance.collection("YoNunca");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: TextField(
                decoration: InputDecoration(errorText: errorFrase, hintText: "Escribe tu Yo nunca"),
                onChanged: (value) {
                  frase = value;
                  setState(() {});
                  errorFrase = null;
                },
              ),
            ),
            SizedBox(
              height: 30,
            ),
            RaisedButton(
              child: Text("Enviar"),
              onPressed: () async {
                if (frase == null || frase.length < 10) {
                  errorFrase = "Demasiado corta";
                  setState(() {});
                  return;
                }
                if (!frase.startsWith("Yo nunca")) {
                  errorFrase = "Tiene que empezar por Yo nunca";
                  setState(() {});
                  return;
                }
                await FraseBloc.addFrase(frase: frase);
                print("Added num : $num");
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      ),
    );
  }
}
