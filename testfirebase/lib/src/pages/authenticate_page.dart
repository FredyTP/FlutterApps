import 'package:flutter/material.dart';
import 'package:testfirebase/src/pages/login_page.dart';
import 'package:testfirebase/src/pages/signin_page.dart';

class AuthenticatePage extends StatefulWidget {
  AuthenticatePage({Key key}) : super(key: key);

  @override
  _AuthenticatePageState createState() => _AuthenticatePageState();
}

class _AuthenticatePageState extends State<AuthenticatePage> {
  bool showSignIn = true;

  void toggleView() {
    setState(() {
      showSignIn = !showSignIn;
      print("Toggled!");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: showSignIn ? SignInPage(toggleForm: toggleView) : LoginPage(toggleForm: toggleView),
    );
  }
}
