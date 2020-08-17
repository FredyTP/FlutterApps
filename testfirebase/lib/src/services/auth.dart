import 'package:firebase_auth/firebase_auth.dart';
import 'package:testfirebase/0villa/models/auth_result_wrapper.dart';
import 'package:testfirebase/src/models/user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //Create user obj base on FirabaseUser

  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  //auth change user stream
  Stream<User> get user {
    return _auth.onAuthStateChanged.map(_userFromFirebaseUser);
  }

  Stream<FirebaseUser> get userRaw {
    return _auth.onAuthStateChanged;
  }

  // sign in anon
  Future signInAnon() async {
    try {
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<FirebaseUser> currentUser() async {
    return await _auth.currentUser();
  }

  // sign in with email and password
  Future<AuthResult> signInEmailPass({String email, String password}) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return result;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // register with email & passwrod
  Future<AuthResultWrapper> createUserEmailPass({String email, String password, bool verificateEmail = true}) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      if (verificateEmail) await result.user.sendEmailVerification();
      return AuthResultWrapper(result: result);
    } catch (e) {
      print(e.toString());
      return AuthResultWrapper(error: e);
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
