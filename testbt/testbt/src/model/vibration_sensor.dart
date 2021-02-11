class VibrationSensor {
  int samplingFrequency; //Frecuencia de muestreo 1Hz-26kHz
  bool connected; //If the sensor is connected
  bool used; //If the sensor is going to be used
  static const int maxSamplingFrequency = 26000;
  VibrationSensor({this.samplingFrequency = maxSamplingFrequency, this.connected = false, this.used = true});
}
