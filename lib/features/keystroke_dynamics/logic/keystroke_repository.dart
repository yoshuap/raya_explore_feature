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

    return KeystrokeAnalysis(
      averageDwellTime: avgDwellTime,
      averageFlightTime: avgFlightTime,
      typingSpeed: typingSpeed,
      totalKeystrokes: _events.length,
      dwellTimeStdDev: dwellStdDev,
      flightTimeStdDev: flightStdDev,
    );
  }

  /// Clears all recorded keystroke data
  void clear() {
    _events.clear();
  }

  /// Gets the total number of recorded keystrokes
  int get keystrokeCount => _events.length;
}
