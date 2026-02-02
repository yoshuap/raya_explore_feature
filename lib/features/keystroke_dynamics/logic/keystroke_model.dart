/// Represents a single keystroke event with timing information.
class KeystrokeEvent {
  /// The character that was typed
  final String character;

  /// Timestamp when the key was pressed (in milliseconds since epoch)
  final int pressTime;

  /// Timestamp when the key was released (in milliseconds since epoch)
  final int releaseTime;

  /// Duration the key was held down (dwell time) in milliseconds
  int get dwellTime => releaseTime - pressTime;

  const KeystrokeEvent({
    required this.character,
    required this.pressTime,
    required this.releaseTime,
  });

  @override
  String toString() {
    return 'KeystrokeEvent(char: $character, dwell: ${dwellTime}ms)';
  }
}

/// Represents aggregated analysis of keystroke patterns.
class KeystrokeAnalysis {
  /// Average time a key is held down (dwell time) in milliseconds
  final double averageDwellTime;

  /// Average time between key presses (flight time) in milliseconds
  final double averageFlightTime;

  /// Typing speed in characters per minute
  final double typingSpeed;

  /// Total number of keystrokes recorded
  final int totalKeystrokes;

  /// Standard deviation of dwell times
  final double dwellTimeStdDev;

  /// Standard deviation of flight times
  final double flightTimeStdDev;

  const KeystrokeAnalysis({
    required this.averageDwellTime,
    required this.averageFlightTime,
    required this.typingSpeed,
    required this.totalKeystrokes,
    required this.dwellTimeStdDev,
    required this.flightTimeStdDev,
  });

  /// Creates an empty analysis with zero values
  factory KeystrokeAnalysis.empty() {
    return const KeystrokeAnalysis(
      averageDwellTime: 0,
      averageFlightTime: 0,
      typingSpeed: 0,
      totalKeystrokes: 0,
      dwellTimeStdDev: 0,
      flightTimeStdDev: 0,
    );
  }

  @override
  String toString() {
    return 'KeystrokeAnalysis(avgDwell: ${averageDwellTime.toStringAsFixed(1)}ms, '
        'avgFlight: ${averageFlightTime.toStringAsFixed(1)}ms, '
        'speed: ${typingSpeed.toStringAsFixed(1)} CPM, '
        'total: $totalKeystrokes)';
  }
}
