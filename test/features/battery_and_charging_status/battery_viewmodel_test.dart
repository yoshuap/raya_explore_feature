import 'dart:async';
import 'package:battery_plus/battery_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'package:mocktail/mocktail.dart';
import 'package:raya_explore_feature/features/battery_and_charging_status/logic/battery_repository.dart';
import 'package:raya_explore_feature/features/battery_and_charging_status/logic/battery_viewmodel.dart';

class MockBattery extends Mock implements Battery {}

void main() {
  late MockBattery mockBattery;
  late BatteryRepository repository;
  late BatteryViewModel viewModel;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    mockBattery = MockBattery();
    repository = BatteryRepository(battery: mockBattery);

    // Default mock behavior
    when(() => mockBattery.batteryLevel).thenAnswer((_) async => 80);
    when(() => mockBattery.isInBatterySaveMode).thenAnswer((_) async => false);
    when(
      () => mockBattery.onBatteryStateChanged,
    ).thenAnswer((_) => Stream.fromIterable([BatteryState.discharging]));

    // Mock the MethodChannel bridge
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(const MethodChannel('battery_bridge'), (
          MethodCall methodCall,
        ) async {
          if (methodCall.method == 'getBatteryStatus') {
            return <String, dynamic>{
              'isCharging': false,
              'isPlugged': false,
              'isConnectedNotCharging': false,
              'batteryLevel': 80,
              'batteryHealth': 'Good',
              'isUsbConnected': false,
              'isUsbConfigured': true,
            };
          }
          return null;
        });
  });

  group('BatteryViewModel Tests -', () {
    test(
      'Initial battery level, save mode, health, and usb status are set correctly',
      () async {
        viewModel = BatteryViewModel(repository);

        // Wait for initialization
        await Future.delayed(Duration.zero);

        expect(viewModel.batteryLevel, 80);
        expect(viewModel.isBatterySaveMode, false);
        expect(viewModel.batteryState, BatteryState.discharging);
        expect(viewModel.batteryHealth, 'Good');
        expect(viewModel.isUsbDataConnected, true);
      },
    );

    test('Battery state changes update the view model', () async {
      final stateController = StreamController<BatteryState>();
      when(
        () => mockBattery.onBatteryStateChanged,
      ).thenAnswer((_) => stateController.stream);

      viewModel = BatteryViewModel(repository);
      await Future.delayed(Duration.zero);

      stateController.add(BatteryState.charging);
      await Future.delayed(Duration.zero);
      expect(viewModel.batteryState, BatteryState.charging);

      stateController.add(BatteryState.full);
      await Future.delayed(Duration.zero);
      expect(viewModel.batteryState, BatteryState.full);

      stateController.close();
    });

    test('Battery level updates when battery state changes', () async {
      final stateController = StreamController<BatteryState>();
      when(
        () => mockBattery.onBatteryStateChanged,
      ).thenAnswer((_) => stateController.stream);

      var levelCount = 0;
      when(() => mockBattery.batteryLevel).thenAnswer((_) async {
        levelCount++;
        return 80 + levelCount;
      });

      viewModel = BatteryViewModel(repository);
      await Future.delayed(Duration.zero);

      stateController.add(BatteryState.charging);
      await Future.delayed(Duration.zero);

      // Initial 1 (in _init) + 1 (in _updateBatteryLevel after state change)
      expect(viewModel.batteryLevel, 82);

      stateController.close();
    });
  });
}
