import 'package:YoNunca/src/app_state.dart';
import 'package:YoNunca/src/models/user_data.dart';
import 'package:flutter/material.dart';

class AddFriendPage extends StatefulWidget {
  AddFriendPage({Key key}) : super(key: key);

  @override
  _AddFriendPageState createState() => _AddFriendPageState();
}

class _AddFriendPageState extends State<AddFriendPage> {
  String searchFriend = "";
  bool showSearchBar = false;
  @override
  Widget build(BuildContext context) {
    final bloc = AppStateContainer.of(context).blocProvider;
    final user = bloc.appUserBloc.currentUser.userData;
    return Scaffold(
      appBar: AppBar(
        actions: [
          FlatButton.icon(
            icon: Icon(showSearchBar ? Icons.cancel : Icons.search),
            label: Text(showSearchBar ? "" : "Buscar"),
            onPressed: () => setState(() {
              showSearchBar = !showSearchBar;
              searchFriend = "";
            }),
          )
        ],
        title: showSearchBar
            ? TextField(
                autofocus: true,
                onChanged: (value) {
                  setState(() {
                    searchFriend = value;
                  });
                },
              )
            : Container(),
      ),
      body: StreamBuilder(
        stream: bloc.adminBloc.usersStream(),
        builder: (context, AsyncSnapshot<List<UserData>> snapshot) {
          if (snapshot.hasData) {
            if (searchFriend.length > 0) {
              final userList = snapshot.data;
              userList.retainWhere((element) => element.userName.toLowerCase().contains(searchFriend.toLowerCase()));
              userList.removeWhere((element) => element.uid == user.uid);
              if (userList.length == 0) {
                return ListTile(title: Text("No se han encontrado usuarios con ese nombre"));
              }
              return ListView.builder(
                itemCount: userList.length,
                itemBuilder: (context, index) {
                  final userResult = userList[index];
                  return ListTile(
                    title: Text(userResult.userName),
                    trailing: user.friends.contains(userResult.uid)
                        ? Text("Ya Agregado")
                        : hasRequest(userUID: user.uid, target: userResult)
                            ? Text("Peticion enviada")
                            : FlatButton.icon(
                                onPressed: () {
                                  bloc.friendsBloc.sendFriendRequest(userUID: bloc.appUserBloc.currentUser.userData.uid, friendUID: userList[index].uid);
                                },
                                icon: Icon(Icons.add),
                                label: Text("Agregar")),
                  );
                },
              );
            }
            return ListView();
          } else {
            return ListView();
          }
        },
      ),
    );
  }

  bool hasRequest({String userUID, UserData target}) {
    bool _isRequested = false;
    target.friendRequests.forEach((element) {
      if (element.userUID == userUID) {
        _isRequested = true;
      }
    });
    return _isRequested;
  }
}
