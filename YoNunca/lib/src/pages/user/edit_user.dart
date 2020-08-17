import 'package:YoNunca/src/app_state.dart';
import 'package:YoNunca/src/models/user_data.dart';
import 'package:flutter/material.dart';

class EditUserPage extends StatefulWidget {
  final String uid;
  const EditUserPage({Key key, this.uid}) : super(key: key);

  @override
  _EditUserPageState createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  UserData user;

  String username;
  bool validUserName = false;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final bloc = AppStateContainer.of(context).blocProvider;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Edit User"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
        child: StreamBuilder(
          stream: bloc.adminBloc.userStreamFromUID(widget.uid),
          builder: (context, AsyncSnapshot<List<UserData>> snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            } else {
              if (snapshot.data.length == 0) {
                Navigator.of(context).pop();
              }
              user = snapshot.data[0];

              return ListView(
                children: [
                  ListTile(
                    title: TextFormField(
                        initialValue: user.userName,
                        decoration: InputDecoration(
                          labelText: "User Name",
                          labelStyle: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
                          border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(6))),
                          helperText: "User Name : ${user.userName}",
                        ),
                        onChanged: (value) {
                          username = value;
                          setState(() {
                            validUserName = _validateUserName();
                          });
                        }),
                    trailing: IconButton(
                      icon: Icon(Icons.send, color: validUserName ? Colors.blue : Colors.grey),
                      onPressed: validUserName
                          ? () {
                              bloc.adminBloc.editUserName(name: username, uid: widget.uid);
                              _showSnackbar(_createUpdateUsernameSnackbar());
                              setState(() {
                                validUserName = false;
                              });
                            }
                          : null,
                    ),
                  ),
                  ListTile(
                    title: RaisedButton(
                      child: Text("DANGER : DELETE ACCOUNT!"),
                      textColor: Colors.white,
                      color: Colors.red,
                      onPressed: () {
                        _showSnackbar(_createDeleteUserTipSnackbar());
                      },
                      onLongPress: () {
                        _showSnackbar(_createUserDeletedSnackbar());
                        bloc.appUserBloc.deleteUserWithUID(widget.uid, bloc.chatBloc, bloc.friendsBloc);
                      },
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  bool _validateUserName() {
    if (user.userName != username && username.length > 3 && username.length < 50) {
      return true;
    }
    return false;
  }

  SnackBar _createDeleteUserTipSnackbar() {
    return SnackBar(
      content: Text(
        "Long press to delete the user",
        textAlign: TextAlign.center,
      ),
    );
  }

  SnackBar _createUserDeletedSnackbar() {
    return SnackBar(
      content: Text(
        "User Deleted",
        textAlign: TextAlign.center,
      ),
    );
  }

  SnackBar _createUpdateUsernameSnackbar() {
    return SnackBar(
      content: Text(
        "Username Updated",
        textAlign: TextAlign.center,
      ),
    );
  }

  void _hideCurrentSnackBar() {
    _scaffoldKey.currentState.hideCurrentSnackBar();
  }

  void _showSnackbar(SnackBar snackBar) {
    _hideCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
