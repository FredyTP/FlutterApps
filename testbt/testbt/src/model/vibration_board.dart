import 'vibration_sensor.dart';

const maxSensorNumber = 4;

class VibrationBoard {
  List<VibrationSensor> sensors = List.filled(maxSensorNumber, VibrationSensor());
}
