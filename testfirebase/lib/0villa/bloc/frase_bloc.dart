import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:testfirebase/0villa/models/frase_model.dart';

class FraseBloc {
  final yonuncaStream = Firestore.instance.collection("YoNunca").orderBy("numero", descending: true).snapshots().asBroadcastStream();

  static Stream<List<FraseModel>> get frasesStream {
    final stream = Firestore.instance.collection("YoNunca").orderBy("numero", descending: true).snapshots().asBroadcastStream();
    return stream.map((event) => event.documents.map((e) => FraseModel.fromJson(e.data)).toList());
  }

  static Future<DocumentReference> addFrase({String frase, String creador = "Anónimo"}) async {
    int numero = await getLength();
    final FraseModel toAdd = FraseModel(frase: frase, creador: creador, numero: numero + 1);
    return await Firestore.instance.collection("YoNunca").add(toAdd.toJson());
  }

  static Future<FraseModel> getRandomYoNunca() async {
    final list = await Firestore.instance.collection("YoNunca").getDocuments();
    int rand = Random().nextInt(list.documents.length);
    return FraseModel.fromJson(list.documents[rand].data);
  }

  static Future<int> getLength() async {
    final list = (await Firestore.instance.collection("YoNunca").getDocuments());
    return list.documents.length;
  }
}
