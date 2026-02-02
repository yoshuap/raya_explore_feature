import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/services.dart';

class BatteryRepository {
  static const _channel = MethodChannel('battery_bridge');
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

  /// Gets granular battery status from the native bridge.
  Future<Map<String, dynamic>> getGranularStatus() async {
    try {
      final result = await _channel.invokeMethod<Map<dynamic, dynamic>>(
        'getBatteryStatus',
      );
      return Map<String, dynamic>.from(result ?? {});
    } catch (e) {
      return {};
    }
  }
}
