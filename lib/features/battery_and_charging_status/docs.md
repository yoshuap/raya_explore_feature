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
- **Battery Save Mode**: Boolean status indicating if the device is in a low-power saving state.

## Why This Feature Matters
- **Awareness**: Users need to know when their device is low on power to avoid unexpected shutdowns.
- **Verification**: Confirms that chargers/cables are functioning correctly by showing the "Charging" state.
- **Optimization**: Visibility into "Battery Save Mode" helps users understand why their device might be throttling performance or background tasks.

## How to Implement This Feature
This feature is implemented using the **Stacked Architecture** and the `battery_plus` package.

### 1. Add Dependency
Add the following to your `pubspec.yaml`:
```yaml
dependencies:
  battery_plus: ^any
```

### 2. Battery Repository
The `BatteryRepository` abstracts the `battery_plus` plugin, providing methods to fetch levels and states.

### 3. Battery ViewModel
The `BatteryViewModel` (extending `BaseViewModel`) manages the lifecycle of the battery state:
- Subscribes to `onBatteryStateChanged` stream.
- Updates battery level whenever the state changes.
- Reacts to app life-cycle (resumed) to refresh status.

### 4. Battery View
The UI uses `ViewModelBuilder<BatteryViewModel>.reactive` to:
- Display a dynamic battery icon based on charging state and level.
- Show the current percentage.
- List details like Save Mode and Last Updated time.
