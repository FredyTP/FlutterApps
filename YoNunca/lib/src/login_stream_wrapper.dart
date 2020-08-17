import 'package:YoNunca/src/app_state.dart';
import 'package:YoNunca/src/pages/signin_page.dart';
import 'package:flutter/material.dart';

import 'models/app_user_event.dart';

class LoginStreamWrapper extends StatefulWidget {
  final Widget child;
  const LoginStreamWrapper({Key key, @required this.child}) : super(key: key);

  @override
  _LoginStreamWrapperState createState() => _LoginStreamWrapperState();
}

class _LoginStreamWrapperState extends State<LoginStreamWrapper> {
  @override
  Widget build(BuildContext context) {
    final bloc = AppStateContainer.of(context).blocProvider.appUserBloc;
    print("From Login Wrapper: ");
    print(bloc.currentUser?.userData?.userName);

    return StreamBuilder(
      stream: bloc.userEventStream,
      builder: (BuildContext context, AsyncSnapshot<AppUserEvent> snapshot) {
        //todo: fix this, should wait not show siginpage if already logged
        if (!snapshot.hasData) {
          if (bloc.isLogged) {
            return widget.child;
          } else {
            return SignInPage();
          }
        } else {
          print(snapshot.data.event);
          if (snapshot.data.event == UserEventType.kDisconnected) {
            return SignInPage();
          } else {
            return widget.child;
          }
        }
      },
    );
  }
}
