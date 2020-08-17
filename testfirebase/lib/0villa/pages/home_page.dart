import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:testfirebase/0villa/app_state.dart';
import 'package:testfirebase/0villa/AppUser.dart';
import 'package:testfirebase/src/services/auth.dart';

class HomePage extends StatelessWidget {
  final FirebaseUser user;
  final AuthService _auth = AuthService();
  HomePage({Key key, this.user}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final userbloc = AppStateContainer.of(context).blocProvider.userDataBloc;
    return StreamBuilder<AppUser>(
        stream: userbloc.userStreamFromFirebaseUser(user),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container(child: CircularProgressIndicator());
          }
          return Scaffold(
            appBar: AppBar(
              title: Text("HomePage"),
              elevation: 0.0,
              actions: <Widget>[FlatButton.icon(onPressed: () => _auth.signOut(), icon: Icon(Icons.person), label: Text("logout"))],
            ),
            drawer: _createDrawer(snapshot.data),
            body: Center(
              child: Text("Bienvenido"),
            ),
          );
        });
  }

  Widget _createDrawer(AppUser user) {
    return Drawer(
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              child: Center(
                  child: ListTile(
                      leading: CircleAvatar(
                        child: FlutterLogo(),
                      ),
                      title: Text("Usuario"),
                      subtitle: Text(user.userData.email))),
              color: Colors.cyan,
              height: 100,
            ),
            Expanded(
              child: Container(
                color: Colors.black,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: ListView.builder(
                    itemBuilder: (context, index) => ListTile(
                      title: Text(index.toString()),
                      tileColor: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              color: Colors.red,
              width: double.infinity,
              child: FlatButton(
                child: Text("Salir"),
                onPressed: _auth.signOut,
              ),
            )
          ],
        ),
      ),
    );
  }
}
