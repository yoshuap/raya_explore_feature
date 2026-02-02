# Sensors Implementation Documentation

## 1. What is?
This feature provides a comprehensive suite of motion, environment, and proximity sensing capabilities for the application. By leveraging various hardware sensors, it allows the app to respond to physical movement, environmental conditions, and device orientation, enabling a more interactive and context-aware user experience.

## 2. Key Metrics Captured
The following sensors and their metrics are tracked:

| Sensor | Metrics Captured | Unit | Plugin |
| :--- | :--- | :--- | :--- |
| **User Accelerometer** | Linear acceleration (excluding gravity) | m/s² | `sensors_plus` |
| **Accelerometer** | Total acceleration (including gravity) | m/s² | `sensors_plus` |
| **Gyroscope** | Rate of rotation around X, Y, Z axes | rad/s | `sensors_plus` |
| **Magnetometer** | Magnetic field strength | μT | `sensors_plus` |
| **Barometer** | Atmospheric pressure | hPa | `sensors_plus` |
| **Temperature** | Ambient room temperature | °C | `environment_sensors` |
| **Humidity** | Relative environmental humidity | % | `environment_sensors` |
| **Light** | Ambient light level | Lux | `environment_sensors` |
| **Proximity** | Distance to nearby objects | Near/Far | `proximity_sensor` |

## 3. Why This Feature Matters
Motion and environment sensors are critical for several reasons:
- **Interactive UI**: Enable features like "shake to reset" or "tilt for perspective".
- **Context Awareness**: Adjust app behavior based on lighting (dark mode) or proximity (screen dimming during calls).
- **Security & Activity Tracking**: Detect unusual device movement or monitor physical activity.
- **Environmental Monitoring**: Provide users with real-time data about their surroundings (e.g., pressure, temperature).

## 4. How to Implement This Feature

### Dependencies
Add the following to your `pubspec.yaml`:
```yaml
dependencies:
  sensors_plus: ^7.0.0
  environment_sensors: ^0.3.0
  proximity_sensor: ^1.3.9
  stacked: ^3.5.0
```

### Platform Setup
- **iOS**: Add `NSMotionUsageDescription` to `Info.plist`.
- **Android**: Ensure `minSdkVersion` 21+.

### Architecture (Stacked + Repository)
1. **Repository (`sensor_repository.dart`)**: Abstraction layer for sensor plugins.
2. **ViewModel (`sensor_viewmodel.dart`)**: Manages stream subscriptions, error handling (availability), and UI state.
3. **View (`view.dart`)**: Reactive UI that updates on every sensor event.

### Testing
Use `mocktail` to simulate sensor streams and verify:
- Initial null states.
- Data updates on stream events.
- Graceful failure (setting `isAvailable` to false) on sensor errors.