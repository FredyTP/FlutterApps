import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:testfirebase/0villa/AppUser.dart';
import 'package:testfirebase/0villa/models/user_data_model.dart';
import 'package:testfirebase/src/services/auth.dart';

class UserDataBloc {
  final userStreamController = StreamController<AppUser>();

  void dispose() {
    userStreamController.close();
  }

  Future addUserToStream(FirebaseUser user) async {
    final usData = UserData.fromJson(await getUserJson(user.uid));
    userStreamController.add(AppUser(firebaseUser: user, userData: usData));
  }

  Stream<AppUser> userStreamFromFirebaseUser(FirebaseUser user) {
    return Firestore.instance.collection("Users").where("uid", isEqualTo: user.uid).snapshots().asBroadcastStream().map((event) => AppUser(firebaseUser: user, userData: UserData.fromJson(event.documents[0].data)));
  }

  static Future getUserJson(String uid) async {
    final docs = (await Firestore.instance.collection("Users").where("uid", isEqualTo: uid).getDocuments()).documents;
    if (docs.length == 0) {
      return null;
    } else {
      return docs[0].data;
    }
  }

  static Future addNewUser(UserData user) async {
    return Firestore.instance.collection("Users").add(user.toJson());
  }
}
