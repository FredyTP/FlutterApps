import 'package:YoNunca/src/app_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/frase_model.dart';
import '../add_frase_page.dart';

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
      appBar: AppBar(
        title: Text("Lista de Yo Nunca"),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_circle),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddFrasePage()));
        },
      ),
      body: StreamBuilder(
        stream: AppStateContainer.of(context).blocProvider.fraseBloc.frasesStream(false),
        builder: (BuildContext context, AsyncSnapshot<List<FraseModel>> snapshot) {
          if (snapshot.hasData) {
            snapshot.data.sort((a, b) => b.rating.compareTo(a.rating));
            return ListView.separated(
                separatorBuilder: (context, index) => Divider(
                      indent: 15,
                      endIndent: 15,
                    ),
                controller: _controller,
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  final item = snapshot.data[index];
                  final String frase = item.frase ?? "No string";
                  final String creator = item.uid;
                  final String rating = item.rating.toStringAsPrecision(3);
                  return ListTile(
                    title: Text(frase),
                    leading: Text(rating),
                    isThreeLine: true,
                    visualDensity: VisualDensity.compact,
                    subtitle: Text(creator),
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
