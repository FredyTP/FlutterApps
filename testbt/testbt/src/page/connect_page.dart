import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

import '../BluetoothDeviceListEntry.dart';

import '../model/bluetooth_info.dart';

class ConnectPage extends StatefulWidget {
  final BluetoothInfo bluetoothInfo;
  ConnectPage({Key key, this.bluetoothInfo}) : super(key: key);

  @override
  _ConnectPageState createState() => _ConnectPageState();
}

class _ConnectPageState extends State<ConnectPage> {
  bool isConnecting = false;
  bool isDisconnecting = false;
  bool ledON = false;
  String tryingToCon = "";
  @override
  void initState() {
    super.initState();

    // Listen for futher state changes
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          FutureBuilder(
            future: FlutterBluetoothSerial.instance.state,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                widget.bluetoothInfo.state = snapshot.data;

                return _buildEnableBT();
              } else {
                return ListTile(title: LinearProgressIndicator());
              }
            },
          ),
          Divider(),
          _buildBody(),
        ],
      ),
    );
  }

  Widget _buildBody() {
    final bt = widget.bluetoothInfo;

    if (isDisconnecting) {
      return ListTile(
        title: Text("Disconnecting to ${bt.connectedDevice.name}"),
        trailing: CircularProgressIndicator(),
      );
    } else if (bt.isConnected) {
      return Column(
        children: [
          ListTile(
            title: Text("Connected to ${bt.connectedDevice.name}"),
            trailing: RaisedButton(
              onPressed: () => disconnect(),
              child: Text("Disconnect"),
            ),
          ),
          ledON
              ? RaisedButton(
                  onPressed: () => setState(() {
                    bt.connection.output.add(utf8.encode("0"));
                    ledON = false;
                  }),
                  child: Text("Turn Off"),
                )
              : RaisedButton(
                  onPressed: () => setState(() {
                    bt.connection.output.add(utf8.encode("1"));
                    ledON = true;
                  }),
                  child: Text("Turn On"),
                )
        ],
      );
    } else if (isConnecting) {
      return ListTile(
        title: Text("Connecting to $tryingToCon"),
        trailing: CircularProgressIndicator(),
      );
    } else {
      return Expanded(
        child: Container(
          margin: EdgeInsets.all(10),
          child: FutureBuilder(
            future: FlutterBluetoothSerial.instance.getBondedDevices(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<BluetoothDevice> bondedDevices = snapshot.data;
                List<BluetoothDeviceListEntry> list = bondedDevices
                    .map((_device) => BluetoothDeviceListEntry(
                          device: _device,
                          rssi: 100,
                          enabled: true,
                          onTap: () {
                            connectToDevice(_device);
                            //Navigator.of(context).pop(_device.device);
                          },
                        ))
                    .toList();
                return ListView(children: list);
              } else
                return CircularProgressIndicator();
            },
          ),
        ),
      );
    }
  }

  Widget _buildEnableBT() {
    final bt = widget.bluetoothInfo;
    return SwitchListTile(
      secondary: Icon(Icons.bluetooth),
      title: Text("Bluetooth"),
      value: bt.state?.isEnabled ?? false,
      onChanged: (bool value) {
        // Do the request and update with the true value then
        future() async {
          // async lambda seems to not working
          if (value) {
            await FlutterBluetoothSerial.instance.requestEnable();
            print("Enabling");
          } else {
            if (bt.isConnected) await disconnect();
            await FlutterBluetoothSerial.instance.requestDisable();
          }
          setState(() {});
        }

        future().then((_) {
          setState(() {});
        });
      },
    );
  }

  Future<int> disconnect() async {
    setState(() {
      isDisconnecting = true;
    });
    await widget.bluetoothInfo.disconnect();
    setState(() {
      isDisconnecting = false;
    });
    return 1;
  }

  void connectToDevice(BluetoothDevice device) {
    final bt = widget.bluetoothInfo;
    if (bt.isConnected) {
      disconnect().then((_) {
        connectToDevice(device);
      });
    } else {
      setState(() {
        isConnecting = true;
        tryingToCon = device.name;
      });
      BluetoothConnection.toAddress(device.address).timeout(Duration(seconds: 10), onTimeout: () {
        print("TIMEOUT");
        return null;
      }).then((connection) {
        if (connection != null) {
          print('Connected to the device');
          bt.connection = connection;
          bt.connectedDevice = device;
        } else {
          print("TIMEOUT, could not connect");
        }

        setState(() {
          isConnecting = false;
        });
      }).catchError((error) {
        print('Cannot connect, exception occured');
        print(error);
        setState(() {
          isConnecting = false;
        });
      });
    }
  }
}
