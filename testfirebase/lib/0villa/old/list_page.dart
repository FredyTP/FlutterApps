import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testfirebase/0villa/bloc/frase_bloc.dart';
import 'package:testfirebase/0villa/old/yonunca_formpage.dart';

import '../models/frase_model.dart';

class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final collection = Firestore.instance.collection("YoNunca"); //.snapshots().asBroadcastStream();
  Stream<QuerySnapshot> list;
  ScrollController _controller = ScrollController();

  @override
  void initState() {
    list = collection.where("tipo", isEqualTo: "frase").orderBy("num", descending: true).snapshots().asBroadcastStream();

    list.listen((event) {
      print("Actualizado");
    });

    _controller.addListener(() {
      if (_controller.position.pixels <= _controller.position.minScrollExtent) {
        //This is not working
        setState(() {
          //list = collection.where("tipo", isEqualTo: "frase").orderBy("num", descending: false).getDocuments().asStream();
          //collect
        });
        //
        //print("updated");
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_circle),
        onPressed: () {
          Navigator.of(context).push(CupertinoPageRoute(
              maintainState: false,
              builder: (BuildContext context) {
                return YoNuncaFormPage();
              }));
        },
      ),
      body: StreamBuilder(
        stream: FraseBloc.frasesStream,
        builder: (BuildContext context, AsyncSnapshot<List<FraseModel>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                controller: _controller,
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  final String frase = snapshot.data[index].frase ?? "No string";
                  final String num = snapshot.data[index].numero.toString();
                  return ListTile(
                    title: Text(num),
                    subtitle: Text(frase),
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    onTap: () {},
                  );
                });
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
