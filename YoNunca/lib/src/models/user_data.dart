import 'dart:convert';

import 'package:YoNunca/src/models/friend_request_model.dart';

class UserData {
  final String userName;
  final String email;
  final String uid;
  final String password;
  final ApplicationLevel level;
  final List<String> friends;
  final List<FriendRequestModel> friendRequests;
//todo: add is Online info
  UserData({this.userName, this.uid, this.email, this.password, this.level = ApplicationLevel.kUser, this.friends = const <String>[], this.friendRequests = const <FriendRequestModel>[]});

  UserData.fromJson(Map<String, dynamic> json)
      : this.userName = json["userName"],
        this.email = json["email"],
        this.level = ApplicationLevel.values[json["level"]],
        this.uid = json["uid"],
        this.password = utf8.decode(base64Url.decode(json["password"])),
        this.friends = json["friends"]?.cast<String>() ?? <String>[],
        this.friendRequests = json["friendRequests"]?.map((doc) => FriendRequestModel.fromJson(doc))?.toList()?.cast<FriendRequestModel>() ?? <FriendRequestModel>[];

  Map<String, dynamic> toJson() {
    return {
      "email": this.email,
      "level": this.level.index,
      "uid": this.uid,
      "userName": this.userName,
      "password": base64Url.encode(utf8.encode(this.password)),
      "friends": this.friends,
      "friendRequests": this.friendRequests.map((e) => e.toJson()).toList(),
    };
  }
}

enum ApplicationLevel {
  kAdmin,
  kUser,
}
