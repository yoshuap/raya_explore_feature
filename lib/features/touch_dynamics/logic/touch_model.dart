import 'dart:math';
import 'package:flutter/material.dart';

/// Represents a single touch point with coordinates, pressure, and timing.
class TouchPoint {
  final double x;
  final double y;
  final double pressure;
  final double size;
  final int timestamp; // milliseconds since epoch

  const TouchPoint({
    required this.x,
    required this.y,
    required this.pressure,
    required this.size,
    required this.timestamp,
  });

  @override
  String toString() {
    return 'TouchPoint(x: ${x.toStringAsFixed(1)}, y: ${y.toStringAsFixed(1)}, p: ${pressure.toStringAsFixed(2)}, s: ${size.toStringAsFixed(2)})';
  }
}

/// Represents a sequence of touch points from touch down to touch up.
class TouchSession {
  final List<TouchPoint> points;
  final int startTime;
  final int endTime;

  TouchSession({
    required this.points,
    required this.startTime,
    required this.endTime,
  });

  int get duration => endTime - startTime;

  double get distance {
    if (points.isEmpty) return 0.0;
    double dist = 0.0;
    for (int i = 0; i < points.length - 1; i++) {
      dist += sqrt(
        pow(points[i + 1].x - points[i].x, 2) +
            pow(points[i + 1].y - points[i].y, 2),
      );
    }
    return dist;
  }

  double get averagePressure {
    if (points.isEmpty) return 0.0;
    return points.map((p) => p.pressure).reduce((a, b) => a + b) /
        points.length;
  }

  double get averageSize {
    if (points.isEmpty) return 0.0;
    return points.map((p) => p.size).reduce((a, b) => a + b) / points.length;
  }

  double get velocity => duration > 0 ? (distance / (duration / 1000.0)) : 0.0;
}

/// Aggregated analysis of multiple touch sessions.
class TouchAnalysis {
  final double avgPressure;
  final double avgSize;
  final double avgVelocity;
  final double avgDuration;
  final double pressureStdDev;
  final double velocityStdDev;
  final int totalSessions;
  final int totalPoints;

  const TouchAnalysis({
    required this.avgPressure,
    required this.avgSize,
    required this.avgVelocity,
    required this.avgDuration,
    required this.pressureStdDev,
    required this.velocityStdDev,
    required this.totalSessions,
    required this.totalPoints,
  });

  factory TouchAnalysis.empty() {
    return const TouchAnalysis(
      avgPressure: 0,
      avgSize: 0,
      avgVelocity: 0,
      avgDuration: 0,
      pressureStdDev: 0,
      velocityStdDev: 0,
      totalSessions: 0,
      totalPoints: 0,
    );
  }

  @override
  String toString() {
    return 'TouchAnalysis(sessions: $totalSessions, avgPressure: ${avgPressure.toStringAsFixed(3)})';
  }
}

/// Represents the interpretation of touch dynamics analysis.
class TouchInterpretation {
  final String title;
  final String description;
  final Color color;
  final IconData icon;

  const TouchInterpretation({
    required this.title,
    required this.description,
    required this.color,
    required this.icon,
  });
}
