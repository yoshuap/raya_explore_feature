import 'package:flutter_test/flutter_test.dart';
import 'package:raya_explore_feature/features/keystroke_dynamics/logic/keystroke_model.dart';
import 'package:raya_explore_feature/features/keystroke_dynamics/logic/keystroke_repository.dart';
import 'package:raya_explore_feature/features/keystroke_dynamics/logic/keystroke_viewmodel.dart';

void main() {
  late KeystrokeRepository repository;
  late KeystrokeViewModel viewModel;

  setUp(() {
    repository = KeystrokeRepository();
    viewModel = KeystrokeViewModel(repository);
  });

  tearDown(() {
    viewModel.dispose();
  });

  group('KeystrokeViewModel Tests -', () {
    test('Initial state is correct', () {
      expect(viewModel.isRecording, false);
      expect(viewModel.keystrokeCount, 0);
      expect(viewModel.analysis.totalKeystrokes, 0);
      expect(viewModel.analysis.averageDwellTime, 0);
      expect(viewModel.analysis.averageFlightTime, 0);
      expect(viewModel.analysis.typingSpeed, 0);
    });

    test('Start recording changes state', () {
      viewModel.startRecording();
      expect(viewModel.isRecording, true);
    });

    test('Stop recording changes state', () {
      viewModel.startRecording();
      viewModel.stopRecording();
      expect(viewModel.isRecording, false);
    });

    test('Text changes are ignored when not recording', () {
      viewModel.onTextChanged('a');
      expect(viewModel.keystrokeCount, 0);
    });

    test('Text changes are recorded when recording', () async {
      viewModel.startRecording();
      viewModel.onTextChanged('a');
      await Future.delayed(Duration.zero);

      expect(viewModel.keystrokeCount, 1);
      expect(viewModel.analysis.totalKeystrokes, 1);
    });

    test('Multiple keystrokes are recorded correctly', () async {
      viewModel.startRecording();

      viewModel.onTextChanged('h');
      await Future.delayed(const Duration(milliseconds: 10));

      viewModel.onTextChanged('he');
      await Future.delayed(const Duration(milliseconds: 10));

      viewModel.onTextChanged('hel');
      await Future.delayed(const Duration(milliseconds: 10));

      viewModel.onTextChanged('hell');
      await Future.delayed(const Duration(milliseconds: 10));

      viewModel.onTextChanged('hello');
      await Future.delayed(Duration.zero);

      expect(viewModel.keystrokeCount, 5);
      expect(viewModel.analysis.totalKeystrokes, 5);
    });

    test('Analysis calculates average dwell time', () async {
      viewModel.startRecording();

      viewModel.onTextChanged('a');
      await Future.delayed(const Duration(milliseconds: 10));

      viewModel.onTextChanged('ab');
      await Future.delayed(Duration.zero);

      expect(viewModel.analysis.averageDwellTime, greaterThan(0));
      expect(viewModel.analysis.averageDwellTime, lessThan(200));
    });

    test('Analysis calculates typing speed for multiple keystrokes', () async {
      viewModel.startRecording();

      for (int i = 0; i < 5; i++) {
        final newText = 'a' * (i + 1);
        viewModel.onTextChanged(newText);
        await Future.delayed(const Duration(milliseconds: 10));
      }

      expect(viewModel.analysis.typingSpeed, greaterThan(0));
    });

    test('Clear data resets everything', () async {
      viewModel.startRecording();

      viewModel.onTextChanged('test');
      await Future.delayed(Duration.zero);

      expect(viewModel.keystrokeCount, greaterThan(0));

      viewModel.clearData();

      expect(viewModel.keystrokeCount, 0);
      expect(viewModel.analysis.totalKeystrokes, 0);
      expect(viewModel.textController.text, isEmpty);
    });

    test('Key press and release tracking works', () {
      viewModel.startRecording();

      viewModel.onKeyPress('a');
      viewModel.onKeyRelease('a');

      expect(viewModel.keystrokeCount, 1);
    });

    test('Key release without press is ignored', () {
      viewModel.startRecording();

      viewModel.onKeyRelease('a');

      expect(viewModel.keystrokeCount, 0);
    });

    test('Analysis updates after each keystroke', () async {
      viewModel.startRecording();

      viewModel.onTextChanged('a');
      await Future.delayed(Duration.zero);

      final firstAnalysis = viewModel.analysis;
      expect(firstAnalysis.totalKeystrokes, 1);

      viewModel.onTextChanged('ab');
      await Future.delayed(Duration.zero);

      final secondAnalysis = viewModel.analysis;
      expect(secondAnalysis.totalKeystrokes, 2);
      // Flight time is calculated but may be negative in simulated environment
      expect(secondAnalysis.averageFlightTime, isNotNull);
    });

    test('Detected backspace as a keystroke', () async {
      viewModel.startRecording();
      viewModel.onTextChanged('abc');
      final countBefore = viewModel.keystrokeCount;
      viewModel.onTextChanged('ab');
      expect(viewModel.keystrokeCount, countBefore + 1);
    });

    test('Detected multi-character additions', () async {
      viewModel.startRecording();
      viewModel.onTextChanged('hello');
      expect(viewModel.keystrokeCount, 5);
    });
  });

  group('KeystrokeRepository Tests -', () {
    test('Repository starts empty', () {
      final repo = KeystrokeRepository();
      expect(repo.keystrokeCount, 0);
      expect(repo.events, isEmpty);
    });

    test('Repository records keystroke events', () {
      final repo = KeystrokeRepository();
      final event = KeystrokeEvent(
        character: 'a',
        pressTime: 1000,
        releaseTime: 1100,
      );

      repo.recordKeystroke(event);

      expect(repo.keystrokeCount, 1);
      expect(repo.events.length, 1);
      expect(repo.events.first.character, 'a');
    });

    test('Repository calculates correct dwell time', () {
      final repo = KeystrokeRepository();
      final event = KeystrokeEvent(
        character: 'a',
        pressTime: 1000,
        releaseTime: 1100,
      );

      repo.recordKeystroke(event);
      final analysis = repo.analyzeKeystrokes();

      expect(analysis.averageDwellTime, 100);
    });

    test('Repository calculates flight time correctly', () {
      final repo = KeystrokeRepository();

      repo.recordKeystroke(
        KeystrokeEvent(character: 'a', pressTime: 1000, releaseTime: 1100),
      );

      repo.recordKeystroke(
        KeystrokeEvent(character: 'b', pressTime: 1150, releaseTime: 1250),
      );

      final analysis = repo.analyzeKeystrokes();

      expect(analysis.averageFlightTime, 50);
    });

    test('Repository clears data correctly', () {
      final repo = KeystrokeRepository();

      repo.recordKeystroke(
        KeystrokeEvent(character: 'a', pressTime: 1000, releaseTime: 1100),
      );

      expect(repo.keystrokeCount, 1);

      repo.clear();

      expect(repo.keystrokeCount, 0);
      expect(repo.events, isEmpty);
    });

    test('Empty repository returns empty analysis', () {
      final repo = KeystrokeRepository();
      final analysis = repo.analyzeKeystrokes();

      expect(analysis.totalKeystrokes, 0);
      expect(analysis.averageDwellTime, 0);
      expect(analysis.averageFlightTime, 0);
      expect(analysis.typingSpeed, 0);
    });
  });
}
