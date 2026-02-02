import 'package:flutter/material.dart';
import 'package:raya_explore_feature/features/keystroke_dynamics/logic/keystroke_model.dart';
import 'package:raya_explore_feature/features/keystroke_dynamics/logic/keystroke_repository.dart';
import 'package:stacked/stacked.dart';

/// ViewModel for managing keystroke dynamics state and logic.
class KeystrokeViewModel extends BaseViewModel {
  final KeystrokeRepository _repository;
  final TextEditingController textController = TextEditingController();

  KeystrokeViewModel(this._repository);

  bool _isRecording = false;
  bool get isRecording => _isRecording;

  KeystrokeAnalysis _analysis = KeystrokeAnalysis.empty();
  KeystrokeAnalysis get analysis => _analysis;

  int get keystrokeCount => _repository.keystrokeCount;

  // Track previous text to detect changes accurately
  String _previousText = '';

  // Track key press times for calculating dwell time
  final Map<String, int> _keyPressStartTimes = {};

  /// Handles key press event
  void onKeyPress(String character) {
    if (!_isRecording) return;

    final now = DateTime.now().millisecondsSinceEpoch;
    _keyPressStartTimes[character] = now;
  }

  /// Handles key release event
  void onKeyRelease(String character) {
    if (!_isRecording) return;

    final releaseTime = DateTime.now().millisecondsSinceEpoch;
    final pressTime = _keyPressStartTimes[character];

    if (pressTime != null) {
      final event = KeystrokeEvent(
        character: character,
        pressTime: pressTime,
        releaseTime: releaseTime,
      );

      _repository.recordKeystroke(event);
      _keyPressStartTimes.remove(character);

      // Update analysis
      _analysis = _repository.analyzeKeystrokes();
      notifyListeners();
    }
  }

  /// Simulates keystroke recording from text input changes
  /// Since Flutter doesn't provide direct key press/release events in TextField,
  /// we simulate timing based on text changes
  void onTextChanged(String newText) {
    if (!_isRecording) return;

    // Detect new characters
    if (newText.length > _previousText.length) {
      final newChar = newText.substring(_previousText.length);
      for (int i = 0; i < newChar.length; i++) {
        _simulateKeystroke(newChar[i]);
      }
    } else if (newText.length < _previousText.length) {
      // Backspace detected - record as a special character for timing analysis
      _simulateKeystroke('⌫');
    }

    _previousText = newText;
  }

  /// Simulates a keystroke with estimated timing
  void _simulateKeystroke(String character) {
    final now = DateTime.now().millisecondsSinceEpoch;
    // Simulate a typical dwell time of 80-120ms
    final dwellTime = 80 + (DateTime.now().microsecond % 40);
    final pressTime = now - dwellTime;

    final event = KeystrokeEvent(
      character: character,
      pressTime: pressTime,
      releaseTime: now,
    );

    _repository.recordKeystroke(event);
    _analysis = _repository.analyzeKeystrokes();
    notifyListeners();
  }

  /// Starts recording keystrokes
  void startRecording() {
    _isRecording = true;
    _previousText = textController.text;
    notifyListeners();
  }

  /// Stops recording keystrokes
  void stopRecording() {
    _isRecording = false;
    _keyPressStartTimes.clear();
    _previousText = '';
    notifyListeners();
  }

  /// Clears all recorded data and resets the analysis
  void clearData() {
    _repository.clear();
    _analysis = KeystrokeAnalysis.empty();
    textController.clear();
    _previousText = '';
    _keyPressStartTimes.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }
}
