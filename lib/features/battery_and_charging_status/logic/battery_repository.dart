import 'package:battery_plus/battery_plus.dart';

class BatteryRepository {
  final Battery _battery;

  BatteryRepository({Battery? battery}) : _battery = battery ?? Battery();

  /// Gets the current battery level.
  Future<int> get batteryLevel => _battery.batteryLevel;

  /// Stream of battery state changes (charging, discharging, etc.).
  Stream<BatteryState> get onBatteryStateChanged =>
      _battery.onBatteryStateChanged;

  /// Check if the device is currently in battery save mode.
  /// Note: This might not be supported on all platforms.
  Future<bool> get isInBatterySaveMode => _battery.isInBatterySaveMode;
}
