import 'dart:async';

import 'package:YoNunca/src/bloc/chat_bloc.dart';
import 'package:YoNunca/src/bloc/friends_bloc.dart';
import 'package:YoNunca/src/models/app_user.dart';
import 'package:YoNunca/src/models/app_user_event.dart';
import 'package:YoNunca/src/models/user_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppUserBloc {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference _userCollection = Firestore.instance.collection("Users");
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
    _auth.onAuthStateChanged.listen((event) {
      print(event.toString());
      if (_isDeleting) {
        _streamController.add(AppUserEvent(event: UserEventType.kDeleting));
      } else {
        if (event == null) {
          _streamController.add(AppUserEvent(event: UserEventType.kDisconnected));
        } else {
          _subscription?.cancel();
          _subscription = _userCollection.where("uid", isEqualTo: event.uid).snapshots().listen((result) {
            if (result == null) {
              _streamController.add(AppUserEvent(event: UserEventType.kDisconnected));
              _currentUser = null;
            } else {
              final len = result.documents.length;
              if (len == 0) {
                _streamController.add(AppUserEvent(event: UserEventType.kDisconnected));
                _currentUser = null;
              } else if (len > 1) {
                _streamController.add(AppUserEvent(event: UserEventType.kDisconnected));
                _currentUser = null;
              } else if (len == 1) {
                print("USER OK");
                _currentUser = AppUser(firebaseUser: event, userData: UserData.fromJson(result.documents[0].data));
                _streamController.add(AppUserEvent(event: UserEventType.kConnected, user: _currentUser));
              }
            }
          });
        }
      }
    });
  }

  Future<UserData> getUserDataFromUID(String uid) async {
    final userList = await _userCollection.where("uid", isEqualTo: uid).getDocuments();
    if (userList.documents.length == 0) {
      print("Error getUserDataFromUID cant find the user");
      return null;
    } else {
      return UserData.fromJson(userList.documents[0].data);
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

  Future createUserEmailPassword({String email, String password, ApplicationLevel level = ApplicationLevel.kUser}) async {
    AuthResult result;
    try {
      result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    } catch (error) {
      print(error.toString());
    }
    try {
      print("OK");

      final tosend = UserData(email: email, password: password, uid: result.user.uid, level: level, userName: "None");
      await _userCollection.add(tosend.toJson());
    } catch (error) {
      await result?.user?.delete();
      print(error.toString());
    }
  }

  Future deleteUserWithUID(String uid, ChatBloc chatBloc, FriendsBloc friendsBloc) async {
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
      await friendsBloc.deleteUserReference(uid: uid);
      final currentuser = await FirebaseAuth.instance.currentUser();
      print("Deleted from database");
      await documentSnapshot.reference.delete();
      print("Deleted user");
      await currentuser.delete();
      await chatBloc.deleteUserChats(uid: uid);
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
