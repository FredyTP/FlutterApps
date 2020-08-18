import 'package:YoNunca/src/app_state.dart';
import 'package:YoNunca/src/pages/friends/add_friend_page.dart';

import 'package:YoNunca/src/pages/friends/friend_requests_page.dart';
import 'package:YoNunca/src/pages/user/perfil_page.dart';
import 'package:flutter/material.dart';

class FriendsPage extends StatefulWidget {
  FriendsPage({Key key}) : super(key: key);

  @override
  _FriendsPageState createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  @override
  Widget build(BuildContext context) {
    final bloc = AppStateContainer.of(context).blocProvider;
    final userData = bloc.appUserBloc.currentUser.userData;
    return Scaffold(
      appBar: AppBar(
        title: Text("Amigos"),
        actions: [
          FlatButton.icon(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddFriendPage())),
            icon: Icon(Icons.person_add),
            label: Text("Añadir Amigo"),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => FriendRequestPage())),
        backgroundColor: Colors.red,
        elevation: 5,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Icon(Icons.receipt), Text(userData.friendRequests.length.toString())], //Mejorar
        ),
      ),
      body: StreamBuilder(
        stream: bloc.friendsBloc.friendsStreamFromUID(uid: bloc.appUserBloc.currentUser.userData.uid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final lista = snapshot.data;

            return ListView.separated(
              separatorBuilder: (context, index) {
                return Divider(
                  height: 4,
                  indent: 10,
                  endIndent: 10,
                );
              },
              itemCount: lista.length,
              itemBuilder: (context, index) {
                final friend = lista[index];
                return FutureBuilder(
                    future: bloc.appUserBloc.getUserDataFromUID(friend),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final friendData = snapshot.data;
                        return ListTile(
                            title: Text(friendData.userName),
                            leading: FlutterLogo(),
                            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => PerfilPage(uid: friend, canEdit: false, isThisUser: false))), //Abrir chat por ahora,
                            trailing: Icon(Icons.details) //FlatButton.icon(color: Colors.red, onPressed: () => bloc.friendsBloc.deleteFriend(uid1: userData.uid, uid2: friend), icon: Icon(Icons.delete_forever), label: Text("Delete")),
                            );
                      }
                      return ListTile(
                        title: LinearProgressIndicator(),
                      );
                    });
              },
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
