import 'package:YoNunca/src/models/user_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AppUser {
  final UserData userData;
  final FirebaseUser firebaseUser;

  AppUser({@required this.firebaseUser, @required this.userData});
}
