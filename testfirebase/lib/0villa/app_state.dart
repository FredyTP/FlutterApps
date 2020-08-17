import 'package:flutter/material.dart';
import 'package:testfirebase/0villa/bloc/bloc_provider.dart';
import 'package:testfirebase/src/services/auth.dart';

class AppStateContainer extends StatefulWidget {
  final Widget child;
  final BlocProvider blocProvider;

  AppStateContainer({Key key, @required this.child, @required this.blocProvider}) : super(key: key);

  @override
  AppState createState() => AppState();

  static AppState of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_AppDataContainer>().appState;
  }
  /*static BlocProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_AppDataContainer>().appState.blocProvider;
  }*/

}

class AppState extends State<AppStateContainer> {
  BlocProvider get blocProvider => widget.blocProvider;

  @override
  void initState() {
    //widget.blocProvider.userDataBloc.init(AuthService());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _AppDataContainer(
      appState: this,
      blocProvider: widget.blocProvider,
      child: widget.child,
    );
  }
}

class _AppDataContainer extends InheritedWidget {
  final AppState appState;
  final BlocProvider blocProvider;

  _AppDataContainer({Key key, @required this.appState, @required Widget child, @required this.blocProvider}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_AppDataContainer oldWidget) {
    return oldWidget.appState != this.appState;
  }
}

/*import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:testfirebase/0villa/models/user_data_model.dart';
import 'package:testfirebase/0villa/pages/home_page.dart';
import 'package:testfirebase/0villa/pages/signin_page.dart';
import 'package:testfirebase/src/services/auth.dart';

class AppWrapper extends StatefulWidget {
  AppWrapper({Key key}) : super(key: key);

  @override
  _AppWrapperState createState() => _AppWrapperState();
}

class _AppWrapperState extends State<AppWrapper> {
  final _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    
  }
}*/
