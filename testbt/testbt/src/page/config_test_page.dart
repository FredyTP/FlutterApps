import 'package:flutter/material.dart';

import '../model/bluetooth_info.dart';
import '../model/vibration_board.dart';
import '../model/vibration_sensor.dart';

class ConfigTestPage extends StatefulWidget {
  final BluetoothInfo bluetoothInfo;
  final VibrationBoard board;
  ConfigTestPage({Key key, @required this.bluetoothInfo, @required this.board}) : super(key: key);

  @override
  _ConfigTestPageState createState() => _ConfigTestPageState();
}

class _ConfigTestPageState extends State<ConfigTestPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      child: Column(
        children: [
          Expanded(
            child: _buildSensorWidgets(widget.board.sensors),
          ),
          ListTile(
            title: Text("Test Duration: 90s"),
          ),
          ListTile(
            title: Text("Test file: test/monday/test1.csv"),
            trailing: Icon(Icons.folder_open_outlined),
          ),
          Expanded(
            child: Container(
              color: Colors.green,
            ),
          ),
          RaisedButton(
            color: Colors.red,
            textColor: Colors.white,
            child: Text("Start TEST"),
            onPressed: () {},
          )
        ],
      ),
    );
  }

  Widget _buildSensorWidgets(List<VibrationSensor> sensors) {
    return Container(
      color: Colors.grey,
      child: Column(
        children: [
          Expanded(child: Row(children: [_buildSensorWidget(sensors[0], 1), _buildSensorWidget(sensors[1], 2)])),
          Expanded(child: Row(children: [_buildSensorWidget(sensors[2], 3), _buildSensorWidget(sensors[3], 4)])),
        ],
      ),
    );
  }

  Widget _buildSensorWidget(VibrationSensor sensor, int idx) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(child: Text("Sensor: $idx")),
      ),
    );
  }
}
