import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BluetoothInfo {
  BluetoothState state;
  BluetoothConnection connection;
  BluetoothDevice connectedDevice;
  BluetoothInfo();

  bool get isConnected => connection == null ? false : true;

  void connect() {}
  Future<void> disconnect() async {
    await connection.finish();
    connection.dispose();
    connection = null;
    connectedDevice = null;
    return;
  }
}
