import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

import '../model/bluetooth_info.dart';
import '../model/vibration_board.dart';
import 'config_test_page.dart';
import 'connect_page.dart';

class MainPage extends StatefulWidget {
  MainPage({Key key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  BluetoothInfo bluetoothInfo = BluetoothInfo();
  VibrationBoard board = VibrationBoard();
  int _pageIndex = 0;
  Timer checkConnectionTimer;

  @override
  void initState() {
    super.initState();
    FlutterBluetoothSerial.instance.onStateChanged().listen((event) {
      setState(() {
        bluetoothInfo.state = event;
        print(event.stringValue);
      });
    });
    checkConnectionTimer = Timer.periodic(Duration(milliseconds: 500), (_) async {
      if (bluetoothInfo.isConnected) {
        if (!bluetoothInfo.connection.isConnected) {
          bluetoothInfo.disconnect().then((value) => setState(() {}));
        }
      }
    });
  }

  @override
  void dispose() {
    checkConnectionTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      ConnectPage(bluetoothInfo: bluetoothInfo),
      ConfigTestPage(bluetoothInfo: bluetoothInfo, board: board),
      Text("Test State"),
    ];
    final Color botomBarBgColor = Color.fromRGBO(30, 30, 30, 1);
    return Scaffold(
      appBar: AppBar(),
      body: pages.elementAt(_pageIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        fixedColor: Colors.white,
        unselectedItemColor: Colors.grey,
        selectedIconTheme: IconThemeData(size: 40),
        selectedFontSize: 0,
        showSelectedLabels: false,
        showUnselectedLabels: true,
        currentIndex: _pageIndex,
        onTap: (value) => setState(() => _pageIndex = value),
        items: [
          BottomNavigationBarItem(label: "Bluetooth", icon: Icon(Icons.bluetooth_rounded), backgroundColor: botomBarBgColor),
          BottomNavigationBarItem(label: "Test Settings", icon: Icon(Icons.settings), backgroundColor: botomBarBgColor),
          BottomNavigationBarItem(label: "Test State", icon: Icon(Icons.remove_red_eye), backgroundColor: botomBarBgColor),
        ],
      ),
    );
  }
}
