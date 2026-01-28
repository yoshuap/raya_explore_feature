import 'package:sensors_plus/sensors_plus.dart';

class SensorRepository {
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
}
