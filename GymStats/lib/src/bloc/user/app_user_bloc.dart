import 'dart:async';

import 'package:GymStats/src/model/app_user.dart';
import 'package:GymStats/src/model/app_user_event.dart';
import 'package:GymStats/src/model/user_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppUserBloc {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference _userCollection = Firestore.instance.collection("users");
  final StreamController<AppUserEvent> _streamController = StreamController<AppUserEvent>.broadcast();
  AppUser _currentUser;

  bool _isDeleting = false;

  bool get isLogged => _currentUser != null;
  //To Cancel old user stream and suscribe to the new one
  StreamSubscription<QuerySnapshot> _subscription;

  Stream<AppUserEvent> get userEventStream => _streamController.stream;

  AppUser get currentUser => _currentUser;

  //Inicializa los listeners para obtener un stream de UserEvent conteniendo la
  //informacion del usuario actual
  void init() {
    print("init AppUserBloc");
    _auth.onAuthStateChanged.listen((event) {
      print("-----Auth State Changed-----");
      print(event.toString());
      if (_isDeleting) {
        _streamController.add(AppUserEvent(event: UserEventType.kDeleting));
      } else {
        if (event == null) {
          _streamController.add(AppUserEvent(event: UserEventType.kDisconnected));
        } else {
          print("-----Subscript to: -----");
          print("-----${event.uid}-----");
          _subscription?.cancel();
          _subscription = _userCollection.where("authUID", isEqualTo: event.uid).snapshots().listen((result) {
            if (result == null) {
              print("-----Cant find user in DATA BASE-----");
              _streamController.add(AppUserEvent(event: UserEventType.kDisconnected));
              _currentUser = null;
            } else {
              final len = result.documents.length;
              if (len == 0) {
                print("-----Cant find user in DATA BASE-----");
                _streamController.add(AppUserEvent(event: UserEventType.kDisconnected));
                _currentUser = null;
              } else if (len > 1) {
                print("-----Cloned user in DATA BASE-----");
                _streamController.add(AppUserEvent(event: UserEventType.kDisconnected));
                _currentUser = null;
              } else if (len == 1) {
                print("-----USER OKEY: LOGGIN IN-----");
                _currentUser = AppUser(firebaseUser: event, userData: UserData.fromFirebase(result.documents[0]));
                _streamController.add(AppUserEvent(event: UserEventType.kConnected, user: _currentUser));
              }
            }
          });
        }
      }
    });
  }

  Future<UserData> getUserDataFromID(String id) async {
    final user = await _userCollection.document(id).get();
    if (user == null) {
      print("Error getUserDataFromID cant find the user");
      return null;
    } else {
      return UserData.fromFirebase(user);
    }
  }

  DocumentReference getUserDocumentFromID(String id) {
    final user = _userCollection.document(id);
    if (user == null) {
      print("Error getUserDocumentFromId cant find the user");
      return null;
    } else {
      return user;
    }
  }

  Future<DocumentSnapshot> getUserDocumentFromUID(String uid) async {
    final userList = await _userCollection.where("uid", isEqualTo: uid).getDocuments();
    if (userList.documents.length == 0) {
      print("Error getUserDataFromUID cant find the user");
      return null;
    } else {
      return userList.documents[0];
    }
  }

  Future<DocumentReference> createUserEmailPassword({String email, String password, ApplicationLevel level = ApplicationLevel.kUser}) async {
    AuthResult result;
    //TODO : improve this funcion to have a feedback about errors;
    try {
      result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    } catch (error) {
      print(error.toString());
      return null;
    }
    try {
      print("OK");

      final tosend = UserData(email: email, password: password, authUID: result.user.uid, level: level, userName: "None");
      return await _userCollection.add(tosend.toJson());
    } catch (error) {
      await result?.user?.delete();
      print(error.toString());
      return null;
    }
  }

  Future deleteUserWithUID(String uid) async {
    DocumentSnapshot documentSnapshot = await getUserDocumentFromUID(uid);
    UserData userData = UserData.fromJson(documentSnapshot.data);
    if (documentSnapshot == null) {
      print("Can't delete the user");
    } else {
      print("begin deletion");
      _isDeleting = true;
      final UserData actualUser = _currentUser.userData;
      AuthCredential credential = EmailAuthProvider.getCredential(email: userData.email, password: userData.password);
      await FirebaseAuth.instance.signInWithCredential(credential);
      print("Signed in");
      final currentuser = await FirebaseAuth.instance.currentUser();
      print("Deleted from database");
      await documentSnapshot.reference.delete();
      print("Deleted user");
      await currentuser.delete();
      await this.logInEmailAndPassword(email: actualUser.email, password: actualUser.password);
      print("Logged in");
      _isDeleting = false;
    }
  }

  Future logInEmailAndPassword({String email, String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (error) {
      print(error.toString());
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
