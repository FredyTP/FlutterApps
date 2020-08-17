import 'package:YoNunca/src/app_state.dart';
import 'package:flutter/material.dart';

class AddFrasePage extends StatefulWidget {
  AddFrasePage({Key key}) : super(key: key);

  @override
  _AddFrasePageState createState() => _AddFrasePageState();
}

class _AddFrasePageState extends State<AddFrasePage> {
  String frase;

  String errorFrase;

  @override
  Widget build(BuildContext context) {
    final bloc = AppStateContainer.of(context).blocProvider;
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
                await bloc.fraseBloc.addFrase(frase: frase, creador: bloc.appUserBloc.currentUser.userData);
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
