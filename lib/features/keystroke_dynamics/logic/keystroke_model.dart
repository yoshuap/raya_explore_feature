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

/// Represents an interpretation of a keystroke metric.
class KeystrokeInterpretation {
  /// The interpretation text (e.g., "Human-like", "Suspiciously Consistent")
  final String label;

  /// The interpretation color for UI feedback
  final String color;

  /// Detailed description of the interpretation
  final String? description;

  const KeystrokeInterpretation({
    required this.label,
    required this.color,
    this.description,
  });

  /// Potential colors for interpretations
  static const String colorGreen = 'green';
  static const String colorOrange = 'orange';
  static const String colorRed = 'red';
  static const String colorBlue = 'blue';

  @override
  String toString() => 'KeystrokeInterpretation(label: $label)';
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

  /// Interpretation for dwell time
  final KeystrokeInterpretation? dwellInterpretation;

  /// Interpretation for flight time
  final KeystrokeInterpretation? flightInterpretation;

  /// Interpretation for typing speed
  final KeystrokeInterpretation? speedInterpretation;

  const KeystrokeAnalysis({
    required this.averageDwellTime,
    required this.averageFlightTime,
    required this.typingSpeed,
    required this.totalKeystrokes,
    required this.dwellTimeStdDev,
    required this.flightTimeStdDev,
    this.dwellInterpretation,
    this.flightInterpretation,
    this.speedInterpretation,
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
      dwellInterpretation: null,
      flightInterpretation: null,
      speedInterpretation: null,
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
