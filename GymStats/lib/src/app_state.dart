import 'package:flutter/material.dart';

import 'bloc/bloc_provider.dart';

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
  bool firstTime = true;
  @override
  void initState() {
    super.initState();

    widget.blocProvider.init();
  }

  @override
  void dispose() {
    widget.blocProvider.dispose();

    super.dispose();
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
    return true;
    //return oldWidget.blocProvider.appUserBloc.currentUser != this.blocProvider.appUserBloc.currentUser; //|| oldWidget.appState != this.appState;
  }
}
