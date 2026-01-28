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
    when(
      () => mockRepository.temperatureEvents,
    ).thenAnswer((_) => Stream.empty());
    when(() => mockRepository.humidityEvents).thenAnswer((_) => Stream.empty());
    when(() => mockRepository.lightEvents).thenAnswer((_) => Stream.empty());
    when(
      () => mockRepository.proximityEvents,
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
      expect(viewModel.temperatureEvent, isNull);
      expect(viewModel.humidityEvent, isNull);
      expect(viewModel.lightEvent, isNull);
      expect(viewModel.proximityEvent, isNull);
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

    test('updates temperatureEvent when repository emits event', () async {
      const event = 25.0;
      when(
        () => mockRepository.temperatureEvents,
      ).thenAnswer((_) => Stream.value(event));

      final viewModel = SensorViewModel(mockRepository);
      await Future.delayed(Duration.zero);

      expect(viewModel.temperatureEvent, equals(event));
    });

    test('updates humidityEvent when repository emits event', () async {
      const event = 50.0;
      when(
        () => mockRepository.humidityEvents,
      ).thenAnswer((_) => Stream.value(event));

      final viewModel = SensorViewModel(mockRepository);
      await Future.delayed(Duration.zero);

      expect(viewModel.humidityEvent, equals(event));
    });

    test('updates lightEvent when repository emits event', () async {
      const event = 100.0;
      when(
        () => mockRepository.lightEvents,
      ).thenAnswer((_) => Stream.value(event));

      final viewModel = SensorViewModel(mockRepository);
      await Future.delayed(Duration.zero);

      expect(viewModel.lightEvent, equals(event));
    });

    test('updates proximityEvent when repository emits event', () async {
      const event = 1;
      when(
        () => mockRepository.proximityEvents,
      ).thenAnswer((_) => Stream.value(event));

      final viewModel = SensorViewModel(mockRepository);
      await Future.delayed(Duration.zero);

      expect(viewModel.proximityEvent, equals(event));
    });

    test(
      'sets availability to false when repository stream emits error',
      () async {
        when(
          () => mockRepository.userAccelerometerEvents,
        ).thenAnswer((_) => Stream.error(Exception('Sensor not supported')));

        final viewModel = SensorViewModel(mockRepository);
        await Future.delayed(Duration.zero);

        expect(viewModel.isUserAccelerometerAvailable, isFalse);
      },
    );
  });
}
