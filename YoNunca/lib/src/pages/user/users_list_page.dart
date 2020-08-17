import 'package:YoNunca/src/app_state.dart';
import 'package:YoNunca/src/models/user_data.dart';
import 'package:YoNunca/src/pages/user/edit_user.dart';
import 'package:YoNunca/src/pages/user/perfil_page.dart';
import 'package:flutter/material.dart';

class UsersListPage extends StatelessWidget {
  const UsersListPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = AppStateContainer.of(context).blocProvider;
    return Scaffold(
        appBar: AppBar(
          title: Text("Users List"),
        ),
        body: Container(
          child: StreamBuilder(
            stream: bloc.adminBloc.noAdminUserStream(),
            builder: (context, AsyncSnapshot<List<UserData>> snapshot) {
              if (snapshot.hasData) {
                return ListView.separated(
                  separatorBuilder: (context, index) => Divider(
                    indent: 15,
                    endIndent: 15,
                  ),
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) => ListTile(
                    title: Text(snapshot.data[index].email),
                    subtitle: Text(snapshot.data[index].userName.toString()),
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PerfilPage(
                                  uid: snapshot.data[index].uid,
                                  isThisUser: false,
                                  canEdit: true,
                                ))),
                  ),
                );
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
        ));
  }
}
