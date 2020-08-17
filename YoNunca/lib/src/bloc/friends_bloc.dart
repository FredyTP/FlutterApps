import 'dart:async';

import 'package:YoNunca/src/models/friend_request_model.dart';
import 'package:YoNunca/src/models/full_friend_request.dart';
import 'package:YoNunca/src/models/user_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FriendsBloc {
  final _usersCollection = Firestore.instance.collection("Users");

  final _friendRequestStreamController = StreamController<List<FullFriendRequest>>.broadcast();
  void checkFriends() {
    // TODO: check if all friends uid exist, otherwise delete them
  }
  void dispose() {
    _friendRequestStreamController.close();
  }

  Future deleteUserReference({String uid}) async {
    final docs = await _usersCollection.where("uid", isEqualTo: uid).getDocuments();
    final user = UserData.fromJson(docs.documents[0].data);
    user.friends.forEach((element) async {
      await deleteFriend(uid1: user.uid, uid2: element);
    });
  }

  Stream<List<String>> friendsStreamFromUID({String uid}) {
    return _usersCollection.where("uid", isEqualTo: uid).getDocuments().asStream().map((event) => UserData.fromJson(event.documents[0].data).friends).asBroadcastStream();
  }

  Future<DocumentSnapshot> getUserFromUId({String uid}) async {
    final docs = await _usersCollection.where("uid", isEqualTo: uid).getDocuments();
    if (docs.documents.length == 1) {
      return docs.documents[0];
    } else {
      print("Error: user not found");
      return null;
    }
  }

  Future sendFriendRequest({String userUID, String friendUID}) async {
    final friend = await getUserFromUId(uid: friendUID);
    final request = FriendRequestModel(userUID: userUID);

    await friend.reference.updateData({
      "friendRequests": FieldValue.arrayUnion([request.toJson()])
    });
  }

  Future acceptFriendRequest({String userUID, FriendRequestModel request}) async {
    final user = await getUserFromUId(uid: userUID);
    await user.reference.updateData({
      "friendRequests": FieldValue.arrayRemove([request.toJson()])
    });
    return await addFriend(uid1: userUID, uid2: request.userUID);
  }

  Stream<List<FriendRequestModel>> getFriendRequestsStream({String uid}) {
    return _usersCollection.where("uid", isEqualTo: uid).snapshots().map((event) => UserData.fromJson(event.documents[0].data).friendRequests);
  }

  Future<FullFriendRequest> fullFriendRequestFromRequest(FriendRequestModel request) async {
    final user = await getUserFromUId(uid: request.userUID);
    final userData = UserData.fromJson(user.data);
    return FullFriendRequest(msg: request.msg, userName: userData.userName, userUID: request.userUID);
  }

  Future rejectFriendRequest({String userUID, FriendRequestModel request}) async {
    final user = await getUserFromUId(uid: userUID);
    return await user.reference.updateData({
      "friendRequests": FieldValue.arrayRemove([request.toJson()])
    });
  }

  Future addFriend({String uid1, String uid2}) async {
    final user1 = await getUserFromUId(uid: uid1);
    final user2 = await getUserFromUId(uid: uid2);

    user1.reference.updateData({
      "friends": FieldValue.arrayUnion([uid2])
    });
    user2.reference.updateData({
      "friends": FieldValue.arrayUnion([uid1])
    });
    return;
  }

  Future deleteFriend({String uid1, String uid2}) async {
    final user1 = await getUserFromUId(uid: uid1);
    final user2 = await getUserFromUId(uid: uid2);
    //TODO: delete all chats of the user or maybe when the user is deleted

    print("Deleting");
    try {
      await user1.reference.updateData({
        "friends": FieldValue.arrayRemove([uid2])
      });
    } catch (e) {}
    try {
      await user2.reference.updateData({
        "friends": FieldValue.arrayRemove([uid1])
      });
    } catch (e) {}

    return;
  }
}
