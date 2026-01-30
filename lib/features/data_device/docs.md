# Device Information Feature

This feature allows the application to fetch and display detailed information about the device it is running on, using the `device_info_plus` package.

## Architecture

The feature follows a structured architecture for data access and state management:

### 1. DeviceInfoRepository
Located at `lib/features/data_device/logic/device_info_repository.dart`.
- Uses `DeviceInfoPlugin` from `device_info_plus`.
- Handles platform detection (Android or iOS).
- Parses platform-specific data into a unified `Map<String, dynamic>`.

### 2. DeviceInfoViewModel
Located at `lib/features/data_device/logic/device_info_viewmodel.dart`.
- Built using the `stacked` package.
- Manages the state of device information fetching.
- Handles loading states and potential errors.

### 3. DataDevice View
Located at `lib/features/data_device/view.dart`.
- Integrates `DeviceInfoViewModel` using `ViewModelBuilder`.
- Displays the fetched information in a scrollable list.
- Provides a refresh action in the app bar.

## Usage

To use the device info feature, simply navigate to the `DataDevice` screen. The information is automatically fetched when the screen is initialized.

```dart
// Example of how the view is structured
ViewModelBuilder<DeviceInfoViewModel>.reactive(
  viewModelBuilder: () => DeviceInfoViewModel(DeviceInfoRepository()),
  builder: (context, viewModel, child) {
    // UI implementation
  },
);
```

## Dependencies

- `device_info_plus`: For accessing device-specific information.
- `stacked`: For state management.
