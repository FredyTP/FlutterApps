import 'package:YoNunca/src/app_state.dart';
import 'package:YoNunca/src/bloc/bloc_provider.dart';
import 'package:YoNunca/src/models/frase_model.dart';
import 'package:YoNunca/src/models/user_data.dart';
import 'package:YoNunca/src/pages/friends/chat_page.dart';
import 'package:YoNunca/src/widgets/YoNuncaListTabWidget.dart';

import 'package:flutter/material.dart';

import 'edit_user.dart';

class PerfilPage extends StatelessWidget {
  final String uid;
  final bool isThisUser;
  final bool canEdit;

  PerfilPage({Key key, @required this.uid, this.isThisUser = true, this.canEdit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = AppStateContainer.of(context).blocProvider;
    return Scaffold(
      appBar: AppBar(
        title: Text(isThisUser ? "Perfil" : "User Info"),
        actions: canEdit
            ? [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => EditUserPage(uid: this.uid)));
                  },
                )
              ]
            : [
                IconButton(
                  icon: Icon(Icons.message, color: Colors.green),
                  onPressed: () {
                    openChat(context, bloc, bloc.appUserBloc.currentUser.userData, uid);
                  },
                )
              ],
      ),
      body: Container(
        child: StreamBuilder(
            stream: bloc.adminBloc.userStreamFromUID(this.uid),
            builder: (context, AsyncSnapshot<List<UserData>> snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              } else {
                if (snapshot.data.length == 0) {
                  Navigator.of(context).pop();
                }
                final user = snapshot.data[0];
                return Column(
                  children: [
                    _createTopBar(bloc, user),
                    Divider(
                      color: Colors.white54,
                      indent: 15,
                      endIndent: 15,
                    ),
                    _logInAsThisUserButton(context, bloc, user),
                    YoNuncaListTabWidget(
                      uid: uid,
                      canEdit: canEdit,
                    )
                  ],
                );
              }
            }),
      ),
    );
  }

  Widget _logInAsThisUserButton(BuildContext context, BlocProvider bloc, UserData user) {
    return canEdit && !isThisUser
        ? RaisedButton(
            color: Colors.green,
            child: Text("Log In as this user"),
            onPressed: () async {
              await bloc.appUserBloc.logInEmailAndPassword(email: user.email, password: user.password);
              //Navigator.of(context).pushNamedAndRemoveUntil("Home", (route) => false);
            },
          )
        : Container();
  }

  Widget _createTopBar(BlocProvider bloc, UserData user) {
    return Container(
      //color: Colors.blue,
      padding: EdgeInsets.all(4),
      child: Row(
        children: [
          _createPerfilImg(img: FlutterLogo(size: 50), name: user.userName),
          Expanded(
            flex: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _createInfoItem(topWidget: _createUserFrasesRating(bloc, user), bot: "Puntuacion"),
                _createInfoItem(topWidget: _createFrasesInfo(bloc, user), bot: "Yo nuncas"),
                _createInfoItem(top: user.friends.length.toString(), bot: "Amigos"),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _createPerfilImg({Widget img, String name}) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(5),
        //color: Colors.green,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: EdgeInsets.all(5),
              child: ClipOval(child: img),
              decoration: BoxDecoration(color: Colors.yellow, border: Border.all(), shape: BoxShape.circle),
              clipBehavior: Clip.antiAlias,
            ),
            Center(child: Text(name, textAlign: TextAlign.center))
          ],
        ),
      ),
      flex: 3,
    );
  }

  Widget _createInfoItem({String top, @required String bot, Widget topWidget}) {
    return Expanded(
      flex: 1,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 7),
        //color: Colors.red,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            top != null
                ? Text(
                    top,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  )
                : topWidget,
            SizedBox(
              height: 7,
            ),
            Text(bot)
          ],
        ),
      ),
    );
  }

  Widget _createUserFrasesRating(BlocProvider bloc, UserData user) {
    return FutureBuilder(
      future: bloc.fraseBloc.getUserFrasesRating(uid: user.uid),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LinearProgressIndicator();
        } else {
          final num rating = snapshot.data;
          return Text(
            rating.toStringAsPrecision(3),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          );
        }
      },
    );
  }

  Widget _createFrasesInfo(BlocProvider bloc, UserData user) {
    return FutureBuilder(
      future: bloc.fraseBloc.getUserNumFrases(uid: user.uid),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LinearProgressIndicator();
        } else {
          final NumFrasesResult numResult = snapshot.data;
          return RichText(
            text: TextSpan(children: [
              TextSpan(text: numResult.aproved.toString(), style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold, fontSize: 20)),
              TextSpan(text: " / ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              TextSpan(text: numResult.pending.toString(), style: TextStyle(color: Colors.yellowAccent, fontWeight: FontWeight.bold, fontSize: 20)),
            ]),
          );
        }
      },
    );
  }

  Future openChat(BuildContext context, BlocProvider bloc, UserData userData, String friendUid) async {
    var chatRef = await bloc.chatBloc.findChat(uid1: userData.uid, uid2: friendUid);
    if (chatRef == null) {
      await bloc.chatBloc.createChat(uid1: userData.uid, uid2: friendUid);
      chatRef = await bloc.chatBloc.findChat(uid1: userData.uid, uid2: friendUid);
    }
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ChatPage(
              chat: chatRef,
            )));
  }
}
