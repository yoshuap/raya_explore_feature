import 'package:flutter_test/flutter_test.dart';
import 'package:raya_explore_feature/features/touch_dynamics/logic/touch_model.dart';
import 'package:raya_explore_feature/features/touch_dynamics/logic/touch_repository.dart';

void main() {
  late TouchRepository repository;

  setUp(() {
    repository = TouchRepository();
  });

  group('TouchRepository Tests -', () {
    test('Initial state is empty', () {
      expect(repository.sessionCount, 0);
      final analysis = repository.analyze();
      expect(analysis.totalSessions, 0);
      expect(analysis.avgPressure, 0);
    });

    test('Add session correctly', () {
      final points = [
        const TouchPoint(
          x: 10,
          y: 10,
          pressure: 0.5,
          size: 1.0,
          timestamp: 1000,
        ),
        const TouchPoint(
          x: 20,
          y: 20,
          pressure: 0.6,
          size: 1.1,
          timestamp: 1100,
        ),
      ];
      final session = TouchSession(
        points: points,
        startTime: 1000,
        endTime: 1100,
      );

      repository.addSession(session);
      expect(repository.sessionCount, 1);

      final analysis = repository.analyze();
      expect(analysis.totalSessions, 1);
      expect(analysis.avgPressure, closeTo(0.55, 0.001));
      expect(analysis.avgDuration, 100);
    });

    test('Calculate average velocity correctly', () {
      // 100 pixels in 0.1 seconds = 1000 px/s
      final points = [
        const TouchPoint(x: 0, y: 0, pressure: 0.5, size: 1.0, timestamp: 1000),
        const TouchPoint(
          x: 100,
          y: 0,
          pressure: 0.5,
          size: 1.0,
          timestamp: 1100,
        ),
      ];
      final session = TouchSession(
        points: points,
        startTime: 1000,
        endTime: 1100,
      );

      repository.addSession(session);
      final analysis = repository.analyze();
      expect(analysis.avgVelocity, closeTo(1000, 0.001));
    });

    test('Calculate standard deviation correctly', () {
      // Session 1: Avg Pressure 0.4
      repository.addSession(
        TouchSession(
          points: [
            const TouchPoint(
              x: 0,
              y: 0,
              pressure: 0.4,
              size: 1.0,
              timestamp: 1000,
            ),
          ],
          startTime: 1000,
          endTime: 1000,
        ),
      );

      // Session 2: Avg Pressure 0.6
      // Mean = 0.5. Variance = ((0.4-0.5)^2 + (0.6-0.5)^2) / 2 = (0.01 + 0.01) / 2 = 0.01. SD = 0.1
      repository.addSession(
        TouchSession(
          points: [
            const TouchPoint(
              x: 0,
              y: 0,
              pressure: 0.6,
              size: 1.0,
              timestamp: 2000,
            ),
          ],
          startTime: 2000,
          endTime: 2000,
        ),
      );

      final analysis = repository.analyze();
      expect(analysis.avgPressure, 0.5);
      expect(analysis.pressureStdDev, closeTo(0.1, 0.001));
    });

    test('Generate correct interpretations', () {
      // Firm Touch (> 0.7)
      final highPressureAnalysis = const TouchAnalysis(
        avgPressure: 0.8,
        avgSize: 1,
        avgVelocity: 500,
        avgDuration: 100,
        pressureStdDev: 0.1,
        velocityStdDev: 50,
        totalSessions: 1,
        totalPoints: 10,
      );
      final interpretations = repository.getInterpretations(
        highPressureAnalysis,
      );
      expect(interpretations.any((i) => i.title == 'Firm Touch'), true);

      // Swift Movement (> 1000)
      final swiftAnalysis = const TouchAnalysis(
        avgPressure: 0.5,
        avgSize: 1,
        avgVelocity: 1200,
        avgDuration: 100,
        pressureStdDev: 0.1,
        velocityStdDev: 50,
        totalSessions: 1,
        totalPoints: 10,
      );
      final swiftInterpretations = repository.getInterpretations(swiftAnalysis);
      expect(
        swiftInterpretations.any((i) => i.title == 'Swift Movement'),
        true,
      );

      // High Consistency
      final consistentAnalysis = const TouchAnalysis(
        avgPressure: 0.5,
        avgSize: 1,
        avgVelocity: 500,
        avgDuration: 100,
        pressureStdDev: 0.02,
        velocityStdDev: 50,
        totalSessions: 3,
        totalPoints: 30,
      );
      final consistentInterpretations = repository.getInterpretations(
        consistentAnalysis,
      );
      expect(
        consistentInterpretations.any((i) => i.title == 'High Consistency'),
        true,
      );
    });

    test('Clear resets repository', () {
      repository.addSession(
        TouchSession(
          points: [
            const TouchPoint(
              x: 0,
              y: 0,
              pressure: 0.5,
              size: 1.0,
              timestamp: 1000,
            ),
          ],
          startTime: 1000,
          endTime: 1000,
        ),
      );
      expect(repository.sessionCount, 1);

      repository.clear();
      expect(repository.sessionCount, 0);
      expect(repository.analyze().totalSessions, 0);
    });
  });
}
