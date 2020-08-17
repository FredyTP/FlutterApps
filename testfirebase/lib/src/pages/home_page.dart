import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testfirebase/src/models/user.dart';
import 'package:testfirebase/src/services/auth.dart';

class HomePage extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("HomePage"),
        backgroundColor: Colors.brown[50],
        elevation: 0.0,
        actions: <Widget>[FlatButton.icon(onPressed: () => _auth.signOut(), icon: Icon(Icons.person), label: Text("logout"))],
      ),
      body: Center(
        child: Text("Id de usuario :${user.uid}"),
      ),
    );
  }
}
