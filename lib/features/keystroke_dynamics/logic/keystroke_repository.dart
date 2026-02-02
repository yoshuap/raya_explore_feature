import 'dart:math';
import 'package:raya_explore_feature/features/keystroke_dynamics/logic/keystroke_model.dart';

/// Repository for managing keystroke data and analysis.
class KeystrokeRepository {
  final List<KeystrokeEvent> _events = [];

  /// Records a new keystroke event
  void recordKeystroke(KeystrokeEvent event) {
    _events.add(event);
  }

  /// Gets all recorded keystroke events
  List<KeystrokeEvent> get events => List.unmodifiable(_events);

  /// Analyzes the recorded keystroke patterns
  KeystrokeAnalysis analyzeKeystrokes() {
    if (_events.isEmpty) {
      return KeystrokeAnalysis.empty();
    }

    // Calculate average dwell time
    final dwellTimes = _events.map((e) => e.dwellTime).toList();
    final avgDwellTime = dwellTimes.reduce((a, b) => a + b) / dwellTimes.length;

    // Calculate dwell time standard deviation
    final dwellVariance =
        dwellTimes
            .map((t) => pow(t - avgDwellTime, 2))
            .reduce((a, b) => a + b) /
        dwellTimes.length;
    final dwellStdDev = sqrt(dwellVariance);

    // Calculate flight times (time between key presses)
    double avgFlightTime = 0;
    double flightStdDev = 0;
    if (_events.length > 1) {
      final flightTimes = <int>[];
      for (int i = 1; i < _events.length; i++) {
        flightTimes.add(_events[i].pressTime - _events[i - 1].releaseTime);
      }
      avgFlightTime = flightTimes.reduce((a, b) => a + b) / flightTimes.length;

      // Calculate flight time standard deviation
      final flightVariance =
          flightTimes
              .map((t) => pow(t - avgFlightTime, 2))
              .reduce((a, b) => a + b) /
          flightTimes.length;
      flightStdDev = sqrt(flightVariance);
    }

    // Calculate typing speed (characters per minute)
    double typingSpeed = 0;
    if (_events.length > 1) {
      final totalTime =
          _events.last.releaseTime - _events.first.pressTime; // in milliseconds
      if (totalTime > 0) {
        final minutes = totalTime / 60000.0;
        typingSpeed = _events.length / minutes;
      }
    }

    // Generate interpretations
    final dwellInterpretation = _interpretDwellConsistency(dwellStdDev);
    final flightInterpretation = _interpretFlightConsistency(flightStdDev);
    final speedInterpretation = _interpretTypingSpeed(typingSpeed);

    return KeystrokeAnalysis(
      averageDwellTime: avgDwellTime,
      averageFlightTime: avgFlightTime,
      typingSpeed: typingSpeed,
      totalKeystrokes: _events.length,
      dwellTimeStdDev: dwellStdDev,
      flightTimeStdDev: flightStdDev,
      dwellInterpretation: dwellInterpretation,
      flightInterpretation: flightInterpretation,
      speedInterpretation: speedInterpretation,
    );
  }

  KeystrokeInterpretation? _interpretDwellConsistency(double stdDev) {
    if (stdDev == 0 && _events.length < 3) return null;
    if (stdDev < 5) {
      return const KeystrokeInterpretation(
        label: 'Suspiciously Consistent',
        color: KeystrokeInterpretation.colorRed,
        description:
            'Key hold durations are nearly identical, which is common in bots or automated scripts.',
      );
    } else if (stdDev < 15) {
      return const KeystrokeInterpretation(
        label: 'Very Consistent',
        color: KeystrokeInterpretation.colorOrange,
        description:
            'Highly consistent key presses. Typical for very skilled typists or specific rhythmic patterns.',
      );
    } else {
      return const KeystrokeInterpretation(
        label: 'Natural Variation',
        color: KeystrokeInterpretation.colorGreen,
        description: 'Normal human variation in key hold duration.',
      );
    }
  }

  KeystrokeInterpretation? _interpretFlightConsistency(double stdDev) {
    if (stdDev == 0 && _events.length < 3) return null;
    if (stdDev < 10) {
      return const KeystrokeInterpretation(
        label: 'Robotic Rhythm',
        color: KeystrokeInterpretation.colorRed,
        description:
            'The gaps between keystrokes are too uniform. This is a strong indicator of non-human input.',
      );
    } else if (stdDev < 30) {
      return const KeystrokeInterpretation(
        label: 'Highly Rhythmic',
        color: KeystrokeInterpretation.colorOrange,
        description:
            'Very steady typing pace. Often seen in professional typists or memorized patterns.',
      );
    } else {
      return const KeystrokeInterpretation(
        label: 'Natural Rhythm',
        color: KeystrokeInterpretation.colorGreen,
        description:
            'Varied pauses between keys, indicating natural human typing behavior.',
      );
    }
  }

  KeystrokeInterpretation? _interpretTypingSpeed(double cpm) {
    if (cpm == 0) return null;
    if (cpm > 800) {
      return const KeystrokeInterpretation(
        label: 'Supersonic (Bot-like)',
        color: KeystrokeInterpretation.colorRed,
        description:
            'Typing speed exceeds realistic human limits (>800 CPM). Likely automated input.',
      );
    } else if (cpm > 500) {
      return const KeystrokeInterpretation(
        label: 'Elite Speed',
        color: KeystrokeInterpretation.colorOrange,
        description:
            'Extremely fast typing. Rare for most users, potentially automated or highly trained.',
      );
    } else {
      return const KeystrokeInterpretation(
        label: 'Human Speed',
        color: KeystrokeInterpretation.colorGreen,
        description: 'Typing speed within the normal human range.',
      );
    }
  }

  /// Clears all recorded keystroke data
  void clear() {
    _events.clear();
  }

  /// Gets the total number of recorded keystrokes
  int get keystrokeCount => _events.length;
}
