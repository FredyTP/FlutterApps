import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:testfirebase/0villa/app_state.dart';
import 'package:testfirebase/0villa/pages/home_page.dart';
import 'package:testfirebase/0villa/pages/signin_page.dart';
import 'package:testfirebase/src/services/auth.dart';

class YoNuncaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _bloc = AppStateContainer.of(context).blocProvider;
    final _auth = AuthService();
    return MaterialApp(
        title: 'Yo Nunca 0Villa',
        home: StreamBuilder(
          stream: _auth.userRaw,
          builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
            //todo: fix this, should wait not show siginpage if already logged
            if (!snapshot.hasData) {
              return SignInPage();
            } else {
              if (true) //snapshot.data.isEmailVerified) {
                return HomePage(user: snapshot.data);
            }
          },
        ));
  }
}
