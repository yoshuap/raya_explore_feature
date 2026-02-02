import 'dart:math';
import 'package:flutter/material.dart';
import 'package:raya_explore_feature/features/touch_dynamics/logic/touch_model.dart';

class TouchRepository {
  final List<TouchSession> _sessions = [];

  void addSession(TouchSession session) {
    _sessions.add(session);
  }

  int get sessionCount => _sessions.length;

  void clear() {
    _sessions.clear();
  }

  TouchAnalysis analyze() {
    if (_sessions.isEmpty) {
      return TouchAnalysis.empty();
    }

    double totalPressure = 0;
    double totalSize = 0;
    double totalVelocity = 0;
    double totalDuration = 0;
    int totalPoints = 0;

    for (var session in _sessions) {
      totalPressure += session.averagePressure;
      totalSize += session.averageSize;
      totalVelocity += session.velocity;
      totalDuration += session.duration;
      totalPoints += session.points.length;
    }

    int count = _sessions.length;
    double avgPressure = totalPressure / count;
    double avgVelocity = totalVelocity / count;

    // Calculate standard deviation for pressure and velocity
    double pressureVarSum = 0;
    double velocityVarSum = 0;

    for (var session in _sessions) {
      pressureVarSum += pow(session.averagePressure - avgPressure, 2);
      velocityVarSum += pow(session.velocity - avgVelocity, 2);
    }

    double pressureStdDev = sqrt(pressureVarSum / count);
    double velocityStdDev = sqrt(velocityVarSum / count);

    return TouchAnalysis(
      avgPressure: avgPressure,
      avgSize: totalSize / count,
      avgVelocity: avgVelocity,
      avgDuration: totalDuration / count,
      pressureStdDev: pressureStdDev,
      velocityStdDev: velocityStdDev,
      totalSessions: count,
      totalPoints: totalPoints,
    );
  }

  List<TouchInterpretation> getInterpretations(TouchAnalysis analysis) {
    if (analysis.totalSessions < 1) return [];

    final List<TouchInterpretation> results = [];

    // Pressure Interpretation
    if (analysis.avgPressure > 0.7) {
      results.add(
        const TouchInterpretation(
          title: 'Firm Touch',
          description:
              'You tend to apply significant pressure. This is often associated with high-certainty interactions or specific physical habits.',
          color: Colors.orange,
          icon: Icons.compress,
        ),
      );
    } else if (analysis.avgPressure < 0.3 && analysis.avgPressure > 0) {
      results.add(
        const TouchInterpretation(
          title: 'Light Touch',
          description:
              'You have a very light touch pattern. This can be a distinctive behavioral trait for identification.',
          color: Colors.lightBlue,
          icon: Icons.air,
        ),
      );
    }

    // Velocity Interpretation
    if (analysis.avgVelocity > 1000) {
      results.add(
        const TouchInterpretation(
          title: 'Swift Movement',
          description:
              'Your gestures are very fast. Swift, fluid movements are characteristic of expert-level interaction with the device.',
          color: Colors.green,
          icon: Icons.bolt,
        ),
      );
    } else if (analysis.avgVelocity < 300 && analysis.avgVelocity > 0) {
      results.add(
        const TouchInterpretation(
          title: 'Deliberate Pace',
          description:
              'You move slowly and deliberately. This might indicate caution or a precise interaction style.',
          color: Colors.teal,
          icon: Icons.slow_motion_video,
        ),
      );
    }

    // Consistency Interpretation (using Std Dev)
    if (analysis.totalSessions >= 3) {
      if (analysis.pressureStdDev < 0.05 && analysis.velocityStdDev < 100) {
        results.add(
          const TouchInterpretation(
            title: 'High Consistency',
            description:
                'Your touch patterns are extremely consistent. This "behavioral signature" is key for biometric verification.',
            color: Colors.purple,
            icon: Icons.verified,
          ),
        );
      } else if (analysis.pressureStdDev > 0.2 ||
          analysis.velocityStdDev > 500) {
        results.add(
          const TouchInterpretation(
            title: 'Variable Behavior',
            description:
                'Your patterns show high variability. Behavioral biometrics use this range to build a flexible profile of your identity.',
            color: Colors.blueGrey,
            icon: Icons.vibration,
          ),
        );
      }
    }

    return results;
  }
}
