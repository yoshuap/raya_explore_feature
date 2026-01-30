# Sensors Implementation Documentation

This document describes the step-by-step implementation of the sensors feature using `sensors_plus`, `environment_sensors`, `proximity_sensor`, and **`stacked`**.

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
Add the `NSMotionUsageDescription` key to `ios/Runner/Info.plist`.

```xml
<key>NSMotionUsageDescription</key>
<string>This app needs access to motion sensors to track device movement.</string>
```

### Android
Standard motion sensors usually don't require permissions. However, ensure `minSdkVersion` is compatible with the plugins (typically 21+).

## 3. Architecture

We follow a clean architecture approach using the **Repository** pattern and **Stacked (MVVM)** for state management.

### Layer 1: Repository (`sensor_repository.dart`)
The `SensorRepository` acts as a data source abstraction, wrapping three different plugins:
- **`sensors_plus`**: Provides motion and position sensors.
- **`environment_sensors`**: Provides ambient environment data.
- **`proximity_sensor`**: Provides device proximity data.

| Sensor | Plugin | Unit |
| :--- | :--- | :--- |
| User Accelerometer | `sensors_plus` | m/s² |
| Accelerometer | `sensors_plus` | m/s² |
| Gyroscope | `sensors_plus` | rad/s |
| Magnetometer | `sensors_plus` | μT |
| Barometer | `sensors_plus` | hPa |
| Temperature | `environment_sensors` | °C |
| Humidity | `environment_sensors` | % |
| Light | `environment_sensors` | Lux |
| Proximity | `proximity_sensor` | Near (1) / Far (0) |

### Layer 2: State Management (`sensor_viewmodel.dart`)
The `SensorViewModel` manages sensor subscriptions and availability state:
- **Availability Flags**: Booleans like `is[Sensor]Available` track if a sensor is supported by the hardware.
- **Error Handling**: Uses `.listen(..., onError: ...)` to catch sensor initialization failures and update availability flags.
- **Reactivity**: Calls `notifyListeners()` on every event to update the UI efficiently.
- **Cleanup**: Cancels all `StreamSubscription` objects in `dispose()` to prevent memory leaks.

### Layer 3: UI (`view.dart`)
The UI is built using `ViewModelBuilder.reactive` for a responsive experience.
- **Sensor Cards**: Custom `_buildSensorCard` widgets display data or an error state.
- **Visual Feedback**:
    - **Unavailable State**: Cards turn grey, show a red error icon, and display "Sensor not supported".
    - **Information Tooltips**: Each card includes an info icon that reveals usage instructions on tap.
- **Dynamic Formatting**: Values are formatted to 2 decimal places for consistency.

## 4. Testing

We use `flutter_test` and `mocktail` for unit testing the logic in `SensorViewModel`.

### Key Test Scenarios:
1.  **Initial State**: Verify all sensor events are null.
2.  **Data Updates**: Verify ViewModel state updates when the repository emits a new event.
3.  **Availability Tracking**: Verify availability flags set to `false` when a stream errors out.

```dart
test('sets availability to false when repository stream emits error', () async {
  when(() => mockRepository.userAccelerometerEvents).thenAnswer(
    (_) => Stream.error(Exception('Sensor not supported')),
  );

  final viewModel = SensorViewModel(mockRepository);
  await Future.delayed(Duration.zero);
  
  expect(viewModel.isUserAccelerometerAvailable, isFalse);
});
```