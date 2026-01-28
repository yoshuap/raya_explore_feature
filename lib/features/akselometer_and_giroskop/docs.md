# Sensors Implementation Documentation

This document describes the step-by-step implementation of the sensors feature using `sensors_plus` and **`stacked`**.

## 1. Dependencies

Add the following dependencies to your `pubspec.yaml`:

```yaml
dependencies:
  sensors_plus: ^7.0.0
  environment_sensors: ^0.3.0
  proximity_sensor: ^1.3.9
  stacked: ^3.5.0
```

## 2. Platform Setup

### iOS
Add the `NSMotionUsageDescription` key to `ios/Runner/Info.plist` to request permission to access motion sensors.

```xml
<key>NSMotionUsageDescription</key>
<string>This app needs access to motion sensors to track device movement.</string>
```

### Android
Typically, `sensors_plus` does not require specific permissions for standard sensors (accelerometer, gyroscope, magnetometer) in `AndroidManifest.xml`.
However, `environment_sensors` and `proximity_sensor` might require hardware features to be present.

## 3. Architecture

We follow a clean architecture approach using **Repository** pattern and **Stacked (MVVM)** for state management.

### Layer 1: Repository (`sensor_repository.dart`)
The `SensorRepository` acts as a data source abstraction. It provides streams for all available sensors.
- `userAccelerometerEvents`: Acceleration without gravity.
- `accelerometerEvents`: Raw acceleration including gravity.
- `gyroscopeEvents`: Rotation rate.
- `magnetometerEvents`: Magnetic field.
- `barometerEvents`: Atmospheric pressure.
- `temperatureEvents`: Ambient temperature (°C).
- `humidityEvents`: Relative humidity (%).
- `lightEvents`: Ambient light level (Lux).
- `proximityEvents`: Distance or binary near/far (cm).

### Layer 2: State Management (`sensor_viewmodel.dart`)
- **ViewModel (`SensorViewModel`)**: 
    - Extends `BaseViewModel`.
    - Injects `SensorRepository`.
    - Subscribes to all sensor streams on initialization.
    - Exposes getters for each sensor event type.
    - Tracks availability status for each sensor.
    - Calls `notifyListeners()` when a new event is received to rebuild the UI.
    - Disposes subscriptions in `dispose()`.

### Layer 3: UI (`view.dart`)
The UI uses `ViewModelBuilder.reactive` to bind the `SensorViewModel` to the View.
- **Dependency Injection**: In a production app, use `get_it`. Here we instantiate `SensorViewModel(SensorRepository())` directly in `viewModelBuilder`.
- **Widgets**: `Card` widgets display the X, Y, Z (and P) values for each sensor.

## 4. Testing

We use `flutter_test` and `mocktail` for unit testing.

### `sensor_viewmodel_test.dart`
- Mocks `SensorRepository`.
- Tests that the initial state is empty.
- Tests that the ViewModel correctly updates its state properties when the Repository yields new sensor events.
- Uses `DateTime.now()` for the timestamp requirement in sensor events.

```dart
// Example test case
test('updates userAccelerometerEvent when repository emits event', () async {
  final event = UserAccelerometerEvent(1, 2, 3, DateTime.now());
  when(() => mockRepository.userAccelerometerEvents).thenAnswer(
    (_) => Stream.value(event),
  );

  final viewModel = SensorViewModel(mockRepository);
  await Future.delayed(Duration.zero); // Wait for listener
  
  expect(viewModel.userAccelerometerEvent, equals(event));
});
```