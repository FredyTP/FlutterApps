import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class AuthResultWrapper {
  final AuthResult result;
  final PlatformException error;

  bool get isOk => error == null;

  bool get failed => error != null;

  AuthResultWrapper({this.error, this.result});
}
