/*import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

import 'model/bluetooth_api.dart';

class AppStateContainer extends StatefulWidget {
  final Widget child;
  final BluetoothAPI bluetoothAPI;

  AppStateContainer({Key key, @required this.child, @required this.bluetoothAPI}) : super(key: key);

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
  BluetoothAPI get bluetoothAPI => widget.bluetoothAPI;
  bool firstTime = true;
  @override
  void initState() {
    widget.bluetoothAPI.init();
    FlutterBluetoothSerial.instance.onStateChanged().listen((BluetoothState newstate) {
      setState(() {
        widget.bluetoothAPI.state = newstate;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    FlutterBluetoothSerial.instance.setPairingRequestHandler(null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _AppDataContainer(
      appState: this,
      bluetoothAPI: widget.bluetoothAPI,
      child: widget.child,
    );
  }
}

class _AppDataContainer extends InheritedWidget {
  final AppState appState;
  final BluetoothAPI bluetoothAPI;

  _AppDataContainer({Key key, @required this.appState, @required Widget child, @required this.bluetoothAPI}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_AppDataContainer oldWidget) {
    return true;
    //return oldWidget.blocProvider.appUserBloc.currentUser != this.blocProvider.appUserBloc.currentUser; //|| oldWidget.appState != this.appState;
  }
}*/
