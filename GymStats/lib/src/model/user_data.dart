import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  final String userName;
  final String email;
  final String authUID;
  final String password;
  final ApplicationLevel level;
  final String id;

//todo: add is Online info
  UserData({this.userName, this.authUID, this.email, this.password, this.level = ApplicationLevel.kUser, this.id});
  UserData.fromJson(Map<String, dynamic> json)
      : this.userName = json["userName"],
        this.email = json["email"],
        this.level = ApplicationLevel.values[json["level"]],
        this.authUID = json["authUID"],
        this.password = utf8.decode(base64Url.decode(json["password"])),
        this.id = null;

  UserData.fromFirebase(DocumentSnapshot doc)
      : this.userName = doc.data()["userName"],
        this.email = doc.data()["email"],
        this.level = ApplicationLevel.values[doc.data()["level"]],
        this.authUID = doc.data()["authUID"],
        this.password = utf8.decode(base64Url.decode(doc.data()["password"])),
        this.id = doc.id;

  Map<String, dynamic> toJson() {
    return {
      "email": this.email,
      "level": this.level.index,
      "authUID": this.authUID,
      "userName": this.userName,
      "password": base64Url.encode(utf8.encode(this.password)),
    };
  }
}

enum ApplicationLevel {
  kAdmin,
  kUser,
}
