import 'package:flutter/material.dart';
import 'package:raya_explore_feature/features/touch_dynamics/logic/touch_model.dart';
import 'package:raya_explore_feature/features/touch_dynamics/logic/touch_repository.dart';
import 'package:stacked/stacked.dart';

class TouchViewModel extends BaseViewModel {
  final TouchRepository _repository;

  TouchViewModel(this._repository);

  bool _isRecording = false;
  bool get isRecording => _isRecording;

  TouchAnalysis _analysis = TouchAnalysis.empty();
  TouchAnalysis get analysis => _analysis;

  List<TouchInterpretation> get interpretations =>
      _repository.getInterpretations(_analysis);

  final List<TouchPoint> _currentSessionPoints = [];
  List<TouchPoint> get currentSessionPoints => _currentSessionPoints;

  void startRecording() {
    _isRecording = true;
    notifyListeners();
  }

  void stopRecording() {
    _isRecording = false;
    _currentSessionPoints.clear();
    notifyListeners();
  }

  void handlePointerDown(PointerDownEvent event) {
    if (!_isRecording) return;

    _currentSessionPoints.clear();
    _addPoint(event);
  }

  void handlePointerMove(PointerMoveEvent event) {
    if (!_isRecording) return;
    _addPoint(event);
  }

  void handlePointerUp(PointerUpEvent event) {
    if (!_isRecording) return;

    _addPoint(event);

    if (_currentSessionPoints.isNotEmpty) {
      final session = TouchSession(
        points: List.from(_currentSessionPoints),
        startTime: _currentSessionPoints.first.timestamp,
        endTime: _currentSessionPoints.last.timestamp,
      );

      _repository.addSession(session);
      _analysis = _repository.analyze();
      _currentSessionPoints.clear();
      notifyListeners();
    }
  }

  void _addPoint(PointerEvent event) {
    final point = TouchPoint(
      x: event.position.dx,
      y: event.position.dy,
      pressure: event.pressure,
      size: event.size,
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );
    _currentSessionPoints.add(point);
    notifyListeners();
  }

  void clearData() {
    _repository.clear();
    _analysis = TouchAnalysis.empty();
    _currentSessionPoints.clear();
    notifyListeners();
  }
}
