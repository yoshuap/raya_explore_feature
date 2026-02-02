# Battery and Charging Status

## What is
The **Battery and Charging Status** feature is a real-time monitor for device power information. It retrieves and displays the current battery level, state (charging, discharging, full), and battery save mode status, providing users with essential visibility into their device's energy health.

## Key Metrics Captured
- **Battery Level**: Expressed as a percentage (0-100%).
- **Battery State**: 
  - `Charging`: Device is connected to power and increasing level.
  - `Discharging`: Device is running on battery and decreasing level.
  - `Full`: Device is connected to power and has reached maximum capacity.
  - `Connected Not Charging`: Device is plugged in but not receiving charge.
  - `Unknown`: State cannot be determined.
- **Battery Health**: Current health condition (e.g., Good, Overheat, Dead).
- **Battery Save Mode**: Boolean status indicating if the device is in a low-power saving state.

## Why This Feature Matters
- **Awareness**: Users need to know when their device is low on power to avoid unexpected shutdowns.
- **Verification**: Confirms that chargers/cables are functioning correctly by showing the "Charging" state.
- **Optimization**: Visibility into "Battery Save Mode" helps users understand why their device might be throttling performance or background tasks.

## How to Implement This Feature
This feature is implemented using the **Stacked Architecture**, the `battery_plus` package, and a custom **MethodChannel** bridge for Android.

### 1. Add Dependency
Add the following to your `pubspec.yaml`:
```yaml
dependencies:
  battery_plus: ^any
```

### 2. Native Bridge (Android)
To detect the "Connected Not Charging" state on Android, we use a `MethodChannel` named `battery_bridge` in `MainActivity.kt`. It retrieves granular battery status using `Intent.ACTION_BATTERY_CHANGED`.

### 3. Battery Repository
The `BatteryRepository` abstracts the `battery_plus` plugin and the `MethodChannel`.
- `batteryLevel`: Fetches current level via plugin.
- `onBatteryStateChanged`: Streams plugin state changes.
- `getGranularStatus()`: Invokes the native bridge to check specifically for the `isConnectedNotCharging` flag.

### 4. Battery ViewModel
The `BatteryViewModel` (extending `BaseViewModel`) manages the lifecycle:
- Subscribes to `onBatteryStateChanged`.
- Calls `_updateBatteryLevel()` on state changes.
- Within `_updateBatteryLevel()`, it queries the bridge. If the native status indicates "connected not charging", it overrides the default plugin state with `BatteryState.connectedNotCharging`.

### 5. Battery View
The UI uses `ViewModelBuilder<BatteryViewModel>.reactive` to:
- Display a dynamic battery icon.
- Show the current percentage.
- Handle the `connectedNotCharging` state by showing the "Plugged in, not charging" label.
