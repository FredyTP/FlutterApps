import 'dart:math';

import 'package:YoNunca/src/models/frase_model.dart';
import 'package:YoNunca/src/models/user_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FraseBloc {
  final yonuncaStream = Firestore.instance.collection("YoNunca").snapshots().asBroadcastStream();
  final _collection = Firestore.instance.collection("YoNunca");

  Stream<List<FraseModel>> frasesStream(bool pending) {
    final stream = _collection.where("pending", isEqualTo: pending).snapshots().asBroadcastStream();
    return stream.map((event) => event.documents.map((e) => FraseModel.fromJson(e.data)).toList());
  }

  Stream<List<DocumentSnapshot>> frasesStreamDocuments({bool pending}) {
    final stream = _collection.where("pending", isEqualTo: pending).snapshots().asBroadcastStream();
    return stream.map((event) => event.documents);
  }

  Future voteFrase(DocumentSnapshot frase, num vote) async {
    final toVote = vote.clamp(0, 10);
    final old = FraseModel.fromJson(frase.data);
    final acumVotes = old.votes * old.rating;
    final newRating = (acumVotes + toVote) / (old.votes + 1);
    final increment = newRating - old.rating;

    await frase.reference.updateData({"rating": FieldValue.increment(increment), "votes": FieldValue.increment(1)});
  }

  Stream<QuerySnapshot> get pendingFrasesReferences {
    final stream = _collection.where("pending", isEqualTo: true).snapshots().asBroadcastStream();
    return stream;
  }

  Future<DocumentReference> addFrase({String frase, UserData creador}) async {
    final FraseModel toAdd = FraseModel(frase: frase, uid: creador.uid);
    return await _collection.add(toAdd.toJson());
  }

  void deleteFrase(DocumentReference frase) async {
    await frase.delete();
  }

  Future<DocumentReference> getFraseReference(FraseModel frase) async {
    return (await _collection.where("frase", isEqualTo: frase.frase).getDocuments()).documents[0].reference;
  }

  void deleteFraseFromData(FraseModel frase) async {
    final fraseRef = await getFraseReference(frase);
    await fraseRef.delete();
  }

  void acceptFrase(DocumentReference frase) async {
    await frase.updateData({"pending": false});
  }

  Future<DocumentReference> addFrasefromModel(FraseModel frase) async {
    final FraseModel toAdd = FraseModel(frase: frase.frase, uid: frase.uid, pending: frase.pending, rating: frase.rating, votes: frase.votes);
    return await Firestore.instance.collection("YoNunca").add(toAdd.toJson());
  }

  Future<FraseModel> getRandomYoNunca() async {
    final list = await Firestore.instance.collection("YoNunca").getDocuments();
    int rand = Random().nextInt(list.documents.length);
    return FraseModel.fromJson(list.documents[rand].data);
  }

  Future<int> getLength() async {
    final list = (await Firestore.instance.collection("YoNunca").getDocuments());
    return list.documents.length;
  }

  Future<List<FraseModel>> getUserFrases({String uid, bool pending = false}) async {
    return (await Firestore.instance.collection("YoNunca").where("uid", isEqualTo: uid).where("pending", isEqualTo: pending).getDocuments()).documents.map((e) => FraseModel.fromJson(e.data)).toList();
  }

  Stream<List<FraseModel>> getUserFrasesStream({String uid, bool pending = false}) {
    return Firestore.instance.collection("YoNunca").where("uid", isEqualTo: uid).where("pending", isEqualTo: pending).snapshots().map((event) => event.documents.map((e) => FraseModel.fromJson(e.data)).toList());
  }

  Future<NumFrasesResult> getUserNumFrases({String uid}) async {
    final list = (await Firestore.instance.collection("YoNunca").where("uid", isEqualTo: uid).getDocuments());
    final frases = list.documents;
    int pending = 0;
    int aproved = 0;
    frases.forEach((element) {
      if (element.data["pending"] == true) {
        pending++;
      } else {
        aproved++;
      }
    });
    return NumFrasesResult(aproved: aproved, pending: pending);
  }

  Future<num> getUserFrasesRating({String uid}) async {
    final list = (await Firestore.instance.collection("YoNunca").where("uid", isEqualTo: uid).where("pending", isEqualTo: false).getDocuments());
    num acum = 0;
    int votes = 0;
    list.documents.forEach((element) {
      votes += element.data["votes"];
      acum += (element.data["rating"] * element.data["votes"]);
    });
    return acum / votes;
  }
}
