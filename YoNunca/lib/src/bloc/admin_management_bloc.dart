import 'package:YoNunca/src/models/user_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminManagementBloc {
  final CollectionReference _users = Firestore.instance.collection("Users");

  Stream<List<UserData>> noAdminUserStream() {
    return _users.where("level", isEqualTo: ApplicationLevel.kUser.index).snapshots().map((event) => event.documents.map((e) => UserData.fromJson(e.data)).toList()).asBroadcastStream();
  }

  Stream<List<UserData>> usersStream() {
    return _users.snapshots().map((event) => event.documents.map((e) => UserData.fromJson(e.data)).toList()).asBroadcastStream();
  }

  Stream<List<UserData>> userStreamFromUID(String uid) {
    return _users.where("uid", isEqualTo: uid).snapshots().map((event) => event.documents.map((e) => UserData.fromJson(e.data)).toList()).asBroadcastStream();
  }

  Future<DocumentReference> getUserReference({String uid}) async {
    final userDoc = await _users.where("uid", isEqualTo: uid).getDocuments();
    if (userDoc.documents.length != 1) {
      return null;
    }
    return userDoc.documents[0].reference;
  }

  Future<void> editUserName({String name, String uid}) async {
    final doc = await getUserReference(uid: uid);
    if (doc == null) {
      print("Error: editUserName couldn't find the user id");
      return;
    }
    await doc.updateData({"userName": name});
  }

  Future<void> editUserLevel({ApplicationLevel level, String uid}) async {
    final doc = await getUserReference(uid: uid);
    if (doc == null) {
      print("Error: editUserLevel couldn't find the user id");
      return;
    }
    await doc.updateData({"level": level.index});
  }
}
