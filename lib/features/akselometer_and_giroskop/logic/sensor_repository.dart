import 'package:environment_sensors/environment_sensors.dart';
import 'package:proximity_sensor/proximity_sensor.dart';
import 'package:sensors_plus/sensors_plus.dart';

class SensorRepository {
  final _environmentSensors = EnvironmentSensors();

  Stream<UserAccelerometerEvent> get userAccelerometerEvents =>
      SensorsPlatform.instance.userAccelerometerEventStream();

  Stream<AccelerometerEvent> get accelerometerEvents =>
      SensorsPlatform.instance.accelerometerEventStream();

  Stream<GyroscopeEvent> get gyroscopeEvents =>
      SensorsPlatform.instance.gyroscopeEventStream();

  Stream<MagnetometerEvent> get magnetometerEvents =>
      SensorsPlatform.instance.magnetometerEventStream();

  Stream<BarometerEvent> get barometerEvents =>
      SensorsPlatform.instance.barometerEventStream();

  Stream<double> get temperatureEvents => _environmentSensors.temperature;

  Stream<double> get humidityEvents => _environmentSensors.humidity;

  Stream<double> get lightEvents => _environmentSensors.light;

  Stream<int> get proximityEvents => ProximitySensor.events;
}
