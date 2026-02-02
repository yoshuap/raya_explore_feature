# Device Information Feature

This feature allows the application to fetch and display detailed information about the device it is running on.

## What is it?

The Device Information feature provides a systematic way to retrieve and present hardware and software specifications of the host device. By leveraging the `device_info_plus` package, it abstracts platform-specific complexities (Android vs. iOS) into a unified interface, allowing developers to access critical device attributes during runtime.

## Key Metrics Captured

The feature captures a wide range of metadata tailored to the platform:

### Android Metrics
- **Hardware & Build**: Model, Device, Hardware, Manufacturer, Brand, Product, Board, Bootloader, Type.
- **OS Information**: OS Version (Release), SDK Int, Security Patch level.
- **Identification**: Fingerprint, Tags, Supported ABIs (32/64-bit).
- **Environment**: Is Physical Device, Display specifications.

### iOS Metrics
- **Device Identity**: Name, Model, Localized Model.
- **OS Information**: System Name, System Version.
- **Identification**: Identifier for Vendor.
- **System Details (UTS Name)**: Machine, Nodename, Release, Sysname, Version.
- **Environment**: Is Physical Device status.

## Why This Feature Matters

1.  **Enhanced Debugging**: Provides precise device context when troubleshooting platform-specific issues or performance bottlenecks.
2.  **Device Fingerprinting**: Useful for security and fraud detection by identifying unique device signatures.
3.  **Adaptive UI/UX**: Enables the app to adapt its behavior or interface based on OS version, hardware capabilities, or whether it's running on a physical device vs. an emulator.
4.  **Analytics**: Helps in understanding the hardware distribution of the user base to inform future development priorities.

## How to Implement This Feature

Our implementation follows a clean architecture using the `stacked` package for state management.

### 1. Repository Layer
Create a `DeviceInfoRepository` to handle the data fetching logic using `device_info_plus`.

```dart
// lib/features/data_device/logic/device_info_repository.dart
Future<Map<String, dynamic>> getDeviceInfo() async {
  if (Platform.isAndroid) {
    return _parseAndroidInfo(await _deviceInfoPlugin.androidInfo);
  } else if (Platform.isIOS) {
    return _parseIosInfo(await _deviceInfoPlugin.iosInfo);
  }
  // ...
}
```

### 2. ViewModel Layer
Use a `BaseViewModel` to manage the fetching state and store the retrieved data.

```dart
// lib/features/data_device/logic/device_info_viewmodel.dart
class DeviceInfoViewModel extends BaseViewModel {
  final DeviceInfoRepository _repository;
  Map<String, dynamic> _deviceInfo = {};

  Future<void> _init() async {
    setBusy(true);
    _deviceInfo = await _repository.getDeviceInfo();
    setBusy(false);
  }
}
```

### 3. View Layer
Implement the UI using `ViewModelBuilder` to bind the state to the widget tree.

```dart
// lib/features/data_device/view.dart
@override
Widget build(BuildContext context) {
  return ViewModelBuilder<DeviceInfoViewModel>.reactive(
    viewModelBuilder: () => DeviceInfoViewModel(DeviceInfoRepository()),
    builder: (context, viewModel, child) => Scaffold(
      appBar: AppBar(title: Text('Data Device')),
      body: viewModel.isBusy ? CircularProgressIndicator() : DeviceInfoList(viewModel.deviceInfo),
    ),
  );
}
```

## Dependencies
- `device_info_plus`: For accessing device-specific information.
- `stacked`: For reactive state management and architecture.

