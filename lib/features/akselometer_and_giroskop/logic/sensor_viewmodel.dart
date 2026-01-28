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
  double? _temperatureEvent;
  double? _humidityEvent;
  double? _lightEvent;
  int? _proximityEvent;

  bool _isUserAccelerometerAvailable = true;
  bool _isAccelerometerAvailable = true;
  bool _isGyroscopeAvailable = true;
  bool _isMagnetometerAvailable = true;
  bool _isBarometerAvailable = true;
  bool _isTemperatureAvailable = true;
  bool _isHumidityAvailable = true;
  bool _isLightAvailable = true;
  bool _isProximityAvailable = true;

  UserAccelerometerEvent? get userAccelerometerEvent => _userAccelerometerEvent;
  AccelerometerEvent? get accelerometerEvent => _accelerometerEvent;
  GyroscopeEvent? get gyroscopeEvent => _gyroscopeEvent;
  MagnetometerEvent? get magnetometerEvent => _magnetometerEvent;
  BarometerEvent? get barometerEvent => _barometerEvent;
  double? get temperatureEvent => _temperatureEvent;
  double? get humidityEvent => _humidityEvent;
  double? get lightEvent => _lightEvent;
  int? get proximityEvent => _proximityEvent;

  bool get isUserAccelerometerAvailable => _isUserAccelerometerAvailable;
  bool get isAccelerometerAvailable => _isAccelerometerAvailable;
  bool get isGyroscopeAvailable => _isGyroscopeAvailable;
  bool get isMagnetometerAvailable => _isMagnetometerAvailable;
  bool get isBarometerAvailable => _isBarometerAvailable;
  bool get isTemperatureAvailable => _isTemperatureAvailable;
  bool get isHumidityAvailable => _isHumidityAvailable;
  bool get isLightAvailable => _isLightAvailable;
  bool get isProximityAvailable => _isProximityAvailable;

  final List<StreamSubscription> _subscriptions = [];

  SensorViewModel(this._repository) {
    _initSensors();
  }

  void _initSensors() {
    _subscriptions.add(
      _repository.userAccelerometerEvents.listen(
        (event) {
          _userAccelerometerEvent = event;
          _isUserAccelerometerAvailable = true;
          notifyListeners();
        },
        onError: (error) {
          _isUserAccelerometerAvailable = false;
          notifyListeners();
        },
        cancelOnError: true,
      ),
    );
    _subscriptions.add(
      _repository.accelerometerEvents.listen(
        (event) {
          _accelerometerEvent = event;
          _isAccelerometerAvailable = true;
          notifyListeners();
        },
        onError: (error) {
          _isAccelerometerAvailable = false;
          notifyListeners();
        },
        cancelOnError: true,
      ),
    );
    _subscriptions.add(
      _repository.gyroscopeEvents.listen(
        (event) {
          _gyroscopeEvent = event;
          _isGyroscopeAvailable = true;
          notifyListeners();
        },
        onError: (error) {
          _isGyroscopeAvailable = false;
          notifyListeners();
        },
        cancelOnError: true,
      ),
    );
    _subscriptions.add(
      _repository.magnetometerEvents.listen(
        (event) {
          _magnetometerEvent = event;
          _isMagnetometerAvailable = true;
          notifyListeners();
        },
        onError: (error) {
          _isMagnetometerAvailable = false;
          notifyListeners();
        },
        cancelOnError: true,
      ),
    );
    _subscriptions.add(
      _repository.barometerEvents.listen(
        (event) {
          _barometerEvent = event;
          _isBarometerAvailable = true;
          notifyListeners();
        },
        onError: (error) {
          _isBarometerAvailable = false;
          notifyListeners();
        },
        cancelOnError: true,
      ),
    );
    _subscriptions.add(
      _repository.temperatureEvents.listen(
        (event) {
          _temperatureEvent = event;
          _isTemperatureAvailable = true;
          notifyListeners();
        },
        onError: (error) {
          _isTemperatureAvailable = false;
          notifyListeners();
        },
        cancelOnError: true,
      ),
    );
    _subscriptions.add(
      _repository.humidityEvents.listen(
        (event) {
          _humidityEvent = event;
          _isHumidityAvailable = true;
          notifyListeners();
        },
        onError: (error) {
          _isHumidityAvailable = false;
          notifyListeners();
        },
        cancelOnError: true,
      ),
    );
    _subscriptions.add(
      _repository.lightEvents.listen(
        (event) {
          _lightEvent = event;
          _isLightAvailable = true;
          notifyListeners();
        },
        onError: (error) {
          _isLightAvailable = false;
          notifyListeners();
        },
        cancelOnError: true,
      ),
    );
    _subscriptions.add(
      _repository.proximityEvents.listen(
        (event) {
          _proximityEvent = event;
          _isProximityAvailable = true;
          notifyListeners();
        },
        onError: (error) {
          _isProximityAvailable = false;
          notifyListeners();
        },
        cancelOnError: true,
      ),
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
