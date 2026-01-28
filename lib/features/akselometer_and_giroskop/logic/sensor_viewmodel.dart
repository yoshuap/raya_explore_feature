import 'dart:async';
import 'package:raya_explore_feature/features/akselometer_and_giroskop/logic/sensor_repository.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:stacked/stacked.dart';

class SensorViewModel extends BaseViewModel {
  final SensorRepository _repository;

  UserAccelerometerEvent? _userAccelerometerEvent;
  AccelerometerEvent? _accelerometerEvent;
  GyroscopeEvent? _gyroscopeEvent;
  MagnetometerEvent? _magnetometerEvent;
  BarometerEvent? _barometerEvent;

  UserAccelerometerEvent? get userAccelerometerEvent => _userAccelerometerEvent;
  AccelerometerEvent? get accelerometerEvent => _accelerometerEvent;
  GyroscopeEvent? get gyroscopeEvent => _gyroscopeEvent;
  MagnetometerEvent? get magnetometerEvent => _magnetometerEvent;
  BarometerEvent? get barometerEvent => _barometerEvent;

  final List<StreamSubscription> _subscriptions = [];

  SensorViewModel(this._repository) {
    _initSensors();
  }

  void _initSensors() {
    _subscriptions.add(
      _repository.userAccelerometerEvents.listen((event) {
        _userAccelerometerEvent = event;
        notifyListeners();
      }),
    );
    _subscriptions.add(
      _repository.accelerometerEvents.listen((event) {
        _accelerometerEvent = event;
        notifyListeners();
      }),
    );
    _subscriptions.add(
      _repository.gyroscopeEvents.listen((event) {
        _gyroscopeEvent = event;
        notifyListeners();
      }),
    );
    _subscriptions.add(
      _repository.magnetometerEvents.listen((event) {
        _magnetometerEvent = event;
        notifyListeners();
      }),
    );
    _subscriptions.add(
      _repository.barometerEvents.listen((event) {
        _barometerEvent = event;
        notifyListeners();
      }),
    );
  }

  @override
  void dispose() {
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
    super.dispose();
  }
}
