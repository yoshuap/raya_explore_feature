import 'dart:async';
import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/material.dart';
import 'package:raya_explore_feature/features/battery_and_charging_status/logic/battery_repository.dart';
import 'package:stacked/stacked.dart';

class BatteryViewModel extends BaseViewModel with WidgetsBindingObserver {
  final BatteryRepository _repository;

  BatteryViewModel(this._repository) {
    _init();
    WidgetsBinding.instance.addObserver(this);
  }

  int _batteryLevel = 0;
  int get batteryLevel => _batteryLevel;

  BatteryState? _batteryState;
  BatteryState? get batteryState => _batteryState;

  bool _isBatterySaveMode = false;
  bool get isBatterySaveMode => _isBatterySaveMode;

  StreamSubscription<BatteryState>? _batteryStateSubscription;

  Future<void> _init() async {
    setBusy(true);
    try {
      _batteryLevel = await _repository.batteryLevel;
      _isBatterySaveMode = await _repository.isInBatterySaveMode;

      _batteryStateSubscription = _repository.onBatteryStateChanged.listen((
        state,
      ) {
        _batteryState = state;
        _updateBatteryLevel();
        notifyListeners();
      });
    } catch (e) {
      // Handle error
    } finally {
      setBusy(false);
      notifyListeners();
    }
  }

  Future<void> _updateBatteryLevel() async {
    _batteryLevel = await _repository.batteryLevel;
    notifyListeners();
  }

  Future<void> _refreshBatteryStatus() async {
    _isBatterySaveMode = await _repository.isInBatterySaveMode;
    await _updateBatteryLevel();
    notifyListeners();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refreshBatteryStatus();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _batteryStateSubscription?.cancel();
    super.dispose();
  }
}
