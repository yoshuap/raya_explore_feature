import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:raya_explore_feature/features/akselometer_and_giroskop/logic/sensor_repository.dart';
import 'package:raya_explore_feature/features/akselometer_and_giroskop/logic/sensor_viewmodel.dart';
import 'package:sensors_plus/sensors_plus.dart';

class MockSensorRepository extends Mock implements SensorRepository {}

void main() {
  late MockSensorRepository mockRepository;
  final now = DateTime.now();

  setUp(() {
    mockRepository = MockSensorRepository();
    when(
      () => mockRepository.userAccelerometerEvents,
    ).thenAnswer((_) => Stream.empty());
    when(
      () => mockRepository.accelerometerEvents,
    ).thenAnswer((_) => Stream.empty());
    when(
      () => mockRepository.gyroscopeEvents,
    ).thenAnswer((_) => Stream.empty());
    when(
      () => mockRepository.magnetometerEvents,
    ).thenAnswer((_) => Stream.empty());
    when(
      () => mockRepository.barometerEvents,
    ).thenAnswer((_) => Stream.empty());
  });

  group('SensorViewModel', () {
    test('initial state has null events', () {
      final viewModel = SensorViewModel(mockRepository);
      expect(viewModel.userAccelerometerEvent, isNull);
      expect(viewModel.accelerometerEvent, isNull);
      expect(viewModel.gyroscopeEvent, isNull);
      expect(viewModel.magnetometerEvent, isNull);
      expect(viewModel.barometerEvent, isNull);
    });

    test(
      'updates userAccelerometerEvent when repository emits event',
      () async {
        final event = UserAccelerometerEvent(1, 2, 3, now);
        when(
          () => mockRepository.userAccelerometerEvents,
        ).thenAnswer((_) => Stream.value(event));

        final viewModel = SensorViewModel(mockRepository);
        // Wait for stream listener to process
        await Future.delayed(Duration.zero);

        expect(viewModel.userAccelerometerEvent, equals(event));
      },
    );

    test('updates accelerometerEvent when repository emits event', () async {
      final event = AccelerometerEvent(1, 2, 3, now);
      when(
        () => mockRepository.accelerometerEvents,
      ).thenAnswer((_) => Stream.value(event));

      final viewModel = SensorViewModel(mockRepository);
      await Future.delayed(Duration.zero);

      expect(viewModel.accelerometerEvent, equals(event));
    });

    test('updates gyroscopeEvent when repository emits event', () async {
      final event = GyroscopeEvent(1, 2, 3, now);
      when(
        () => mockRepository.gyroscopeEvents,
      ).thenAnswer((_) => Stream.value(event));

      final viewModel = SensorViewModel(mockRepository);
      await Future.delayed(Duration.zero);

      expect(viewModel.gyroscopeEvent, equals(event));
    });

    test('updates magnetometerEvent when repository emits event', () async {
      final event = MagnetometerEvent(1, 2, 3, now);
      when(
        () => mockRepository.magnetometerEvents,
      ).thenAnswer((_) => Stream.value(event));

      final viewModel = SensorViewModel(mockRepository);
      await Future.delayed(Duration.zero);

      expect(viewModel.magnetometerEvent, equals(event));
    });

    test('updates barometerEvent when repository emits event', () async {
      final event = BarometerEvent(1000, now);
      when(
        () => mockRepository.barometerEvents,
      ).thenAnswer((_) => Stream.value(event));

      final viewModel = SensorViewModel(mockRepository);
      await Future.delayed(Duration.zero);

      expect(viewModel.barometerEvent, equals(event));
    });
  });
}
