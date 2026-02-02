import 'package:flutter/gestures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:raya_explore_feature/features/touch_dynamics/logic/touch_repository.dart';
import 'package:raya_explore_feature/features/touch_dynamics/logic/touch_viewmodel.dart';

void main() {
  late TouchRepository repository;
  late TouchViewModel viewModel;

  setUp(() {
    repository = TouchRepository();
    viewModel = TouchViewModel(repository);
  });

  group('TouchViewModel Tests -', () {
    test('Initial state is correct', () {
      expect(viewModel.isRecording, false);
      expect(viewModel.currentSessionPoints, isEmpty);
      expect(viewModel.analysis.totalSessions, 0);
    });

    test('Start and stop recording toggle state', () {
      viewModel.startRecording();
      expect(viewModel.isRecording, true);

      viewModel.stopRecording();
      expect(viewModel.isRecording, false);
    });

    test('Events are ignored when not recording', () {
      viewModel.handlePointerDown(
        const PointerDownEvent(position: Offset(10, 10)),
      );
      expect(viewModel.currentSessionPoints, isEmpty);
    });

    test('Captures points during recording', () {
      viewModel.startRecording();

      viewModel.handlePointerDown(
        const PointerDownEvent(position: Offset(10, 10), pressure: 0.5),
      );
      expect(viewModel.currentSessionPoints.length, 1);
      expect(viewModel.currentSessionPoints.first.x, 10);

      viewModel.handlePointerMove(
        const PointerMoveEvent(position: Offset(20, 20), pressure: 0.6),
      );
      expect(viewModel.currentSessionPoints.length, 2);
    });

    test('Completes session on pointer up and updates analysis', () async {
      viewModel.startRecording();

      viewModel.handlePointerDown(
        const PointerDownEvent(position: Offset(10, 10), pressure: 0.5),
      );

      // Add a small delay for timestamp difference if needed, but here we just test logic
      viewModel.handlePointerUp(
        const PointerUpEvent(position: Offset(20, 20), pressure: 0.6),
      );

      expect(viewModel.currentSessionPoints, isEmpty);
      expect(viewModel.analysis.totalSessions, 1);
      expect(repository.sessionCount, 1);
    });

    test('Clear data resets state and repository', () {
      viewModel.startRecording();
      viewModel.handlePointerDown(
        const PointerDownEvent(position: Offset(10, 10)),
      );
      viewModel.handlePointerUp(const PointerUpEvent(position: Offset(10, 10)));

      expect(viewModel.analysis.totalSessions, 1);

      viewModel.clearData();
      expect(viewModel.analysis.totalSessions, 0);
      expect(repository.sessionCount, 0);
    });

    test('Interpretations are exposed through viewmodel', () {
      viewModel.startRecording();
      // Simulate high pressure tap
      viewModel.handlePointerDown(const PointerDownEvent(pressure: 0.9));
      viewModel.handlePointerUp(const PointerUpEvent(pressure: 0.9));

      expect(
        viewModel.interpretations.any((i) => i.title == 'Firm Touch'),
        true,
      );
    });
  });
}
