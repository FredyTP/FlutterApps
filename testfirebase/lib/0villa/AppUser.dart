import 'package:firebase_auth/firebase_auth.dart';
import 'package:testfirebase/0villa/bloc/user_data_bloc.dart';
import 'package:testfirebase/0villa/models/user_data_model.dart';

class AppUser {
  UserData userData;
  FirebaseUser firebaseUser;

  AppUser({this.userData, this.firebaseUser});
}
