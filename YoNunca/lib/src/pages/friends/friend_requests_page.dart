import 'package:YoNunca/src/app_state.dart';
import 'package:YoNunca/src/models/friend_request_model.dart';
import 'package:YoNunca/src/models/full_friend_request.dart';
import 'package:YoNunca/src/pages/friends/add_friend_page.dart';
import 'package:flutter/material.dart';

class FriendRequestPage extends StatefulWidget {
  FriendRequestPage({Key key}) : super(key: key);

  @override
  _FriendRequestPageState createState() => _FriendRequestPageState();
}

class _FriendRequestPageState extends State<FriendRequestPage> {
  @override
  Widget build(BuildContext context) {
    final bloc = AppStateContainer.of(context).blocProvider;
    final user = bloc.appUserBloc.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: Text("Solicitudes de Amistad"),
      ),
      body: StreamBuilder(
        stream: bloc.friendsBloc.getFriendRequestsStream(uid: bloc.appUserBloc.currentUser.userData.uid),
        builder: (context, AsyncSnapshot<List<FriendRequestModel>> snapshot) {
          if (snapshot.hasData) {
            final lista = snapshot.data;
            return ListView.builder(
              itemCount: lista.length,
              itemBuilder: (context, index) {
                final request = lista[index];
                return FutureBuilder(
                  future: bloc.friendsBloc.fullFriendRequestFromRequest(request),
                  builder: (context, AsyncSnapshot<FullFriendRequest> snapshot) {
                    if (!snapshot.hasData) {
                      return ListTile(
                        title: LinearProgressIndicator(),
                        subtitle: Text(request.msg),
                      );
                    } else {
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            children: [
                              Text(
                                "Solicitud de : ${snapshot.data.userName}",
                                textScaleFactor: 1.3,
                              ),
                              SizedBox(height: 30),
                              Text(snapshot.data.msg),
                              SizedBox(height: 30),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  FlatButton(
                                    child: Text("Cancelar"),
                                    onPressed: () {
                                      bloc.friendsBloc.rejectFriendRequest(userUID: user.userData.uid, request: request);
                                    },
                                  ),
                                  RaisedButton(
                                    onPressed: () {
                                      bloc.friendsBloc.acceptFriendRequest(userUID: user.userData.uid, request: request);
                                    },
                                    child: Text("Aceptar"),
                                    color: Colors.green,
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    }
                  },
                );
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
