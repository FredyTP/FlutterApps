import 'package:YoNunca/src/app_state.dart';
import 'package:YoNunca/src/bloc/frase_bloc.dart';
import 'package:YoNunca/src/models/app_user.dart';
import 'package:YoNunca/src/models/chat_msg.dart';
import 'package:YoNunca/src/models/frase_model.dart';
import 'package:YoNunca/src/models/user_data.dart';
import 'package:YoNunca/src/pages/add_frase_page.dart';
import 'package:YoNunca/src/pages/friends/friends_page.dart';
import 'package:YoNunca/src/pages/game/pending_frases.dart';
import 'package:YoNunca/src/pages/user/perfil_page.dart';
import 'package:YoNunca/src/pages/user/user_chat_list_page.dart';
import 'package:YoNunca/src/pages/user/users_list_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget build(BuildContext context) {
    final user = AppStateContainer.of(context).blocProvider.appUserBloc.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("0Villa")),
        elevation: 0.0,
        actions: <Widget>[
          FlatButton.icon(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddFrasePage())),
            icon: Icon(Icons.add_circle),
            label: Text("Nuevo Yo Nunca"),
          ),
        ],
      ),
      drawer: _createDrawer(context, user),
      body: _createGameList(context),
    );
  }

  Widget _createGameList(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _createGameCard(
            context,
            "Lista de Yo Nunca",
            Container(
              child: Image.asset(
                "assets/brindis.jpg",
                width: MediaQuery.of(context).size.width * 0.8,
              ),
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            ), () {
          final name = AppStateContainer.of(context).blocProvider.appUserBloc.toString();
          print(name);
          Navigator.of(context).pushNamed("ListYoNunca");
        }),
        _createGameCard(
            context,
            "Yo Nunca Aleatorio",
            Container(
              child: Image.asset(
                "assets/manos_arriba.jpg",
                width: MediaQuery.of(context).size.width * 0.8,
              ),
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            ), () {
          Navigator.of(context).pushNamed("RandomGame");
        })
      ],
    );
  }

  Widget _createGameCard(BuildContext context, String title, Widget image, Function onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
          clipBehavior: Clip.hardEdge,
          elevation: 10,
          color: Colors.grey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              image,
              Container(
                child: Center(
                    child: Text(
                  title,
                  style: TextStyle(fontSize: 30, color: Colors.white),
                )),
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _createDrawer(BuildContext context, AppUser user) {
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
                      title: Text(user.userData.userName),
                      subtitle: Text(user?.userData?.email ?? "Hello"))),
              color: Theme.of(context).primaryColor,
              height: 100,
            ),
            Expanded(
              child: Container(
                color: Color.fromRGBO(170, 170, 170, 1),
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0),
                  child: ListView(
                    children: [
                      ListTile(
                        leading: Icon(Icons.person),
                        title: Text("Perfil"),
                        tileColor: Theme.of(context).primaryColorDark,
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => PerfilPage(
                                    uid: user.userData.uid,
                                    canEdit: true,
                                    isThisUser: true,
                                  )));
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.people),
                        title: Text("Amigos"),
                        tileColor: Theme.of(context).primaryColorDark,
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => FriendsPage()));
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.chat_bubble),
                        title: Text("Chats"),
                        tileColor: Theme.of(context).primaryColorDark,
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => UserChatList()));
                        },
                      ),
                      user.userData.level == ApplicationLevel.kAdmin
                          ? ListTile(
                              leading: Icon(Icons.accessibility),
                              title: Text("Users List"),
                              tileColor: Theme.of(context).primaryColorDark,
                              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => UsersListPage())),
                            )
                          : Container(),
                      user.userData.level == ApplicationLevel.kAdmin
                          ? ListTile(
                              leading: Icon(Icons.view_list),
                              tileColor: Theme.of(context).primaryColorDark,
                              title: Text("Frases Pendientes"),
                              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => PendingFrasesPage())),
                            )
                          : Container()
                    ],
                  ),
                ),
              ),
            ),
            /*RaisedButton(
              color: Colors.pink,
              child: Text("Update user database"),
              onPressed: () async {
                final bloc = AppStateContainer.of(context).blocProvider.fraseBloc;
                final coll = await Firestore.instance.collection("YoNunca").getDocuments();
                coll.documents.forEach((element) {
                  final frase = FraseModel.fromJson(element.data);
                  element.reference.setData(frase.toJson());
                });

                /*final coll = await Firestore.instance.collection("Users").getDocuments();
                final docs = coll.documents;
                for (var doc in docs) {
                  final data = UserData.fromJson(doc.data);
                  doc.reference.setData(data.toJson());
                }*/
                /* final bloc = AppStateContainer.of(context).blocProvider.appUserBloc;
                final UserData userData = user.userData;
                await bloc.createUserEmailPassword(email: "alfredoxperia1@gmail.com", password: "windows11");
                await bloc.logInEmailAndPassword(email: userData.email, password: userData.password);*/
                // user.firebaseUser.delete();
                /*final bloc = AppStateContainer.of(context).blocProvider.fraseBloc;
                await bloc.addFrase(frase: "Yo nunca he jugado a parchis", creador: user.userData.userName);
                await bloc.addFrase(frase: "Yo nunca he jugado a baseball", creador: user.userData.userName);
                await bloc.addFrase(frase: "Yo nunca he jugado a penes", creador: user.userData.userName);
                await bloc.addFrase(frase: "Yo nunca he jugado a pinpon", creador: user.userData.userName);
                await bloc.addFrase(frase: "Yo nunca he jugado a hjacekrmar", creador: user.userData.userName);*/
              },
            ),*/
            Container(
              color: Colors.red,
              width: double.infinity,
              child: FlatButton(
                child: Text("Salir"),
                onPressed: AppStateContainer.of(context).blocProvider.appUserBloc.signOut,
              ),
            )
          ],
        ),
      ),
    );
  }
}
