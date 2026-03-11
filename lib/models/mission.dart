import 'package:flutter/material.dart';

enum MissionPriority {
  high,
  medium,
  utility,
  endgame;

  String get label {
    switch (this) {
      case high:
        return 'HIGH PRIORITY';
      case medium:
        return 'MEDIUM PRIORITY';
      case utility:
        return 'UTILITY';
      case endgame:
        return 'ENDGAME';
    }
  }

  Color get color {
    switch (this) {
      case high:
        return const Color(0xFFEF4444);
      case medium:
        return const Color(0xFFF59E0B);
      case utility:
        return const Color(0xFF3B82F6);
      case endgame:
        return const Color(0xFF22C55E);
    }
  }

  Color get bgColor {
    switch (this) {
      case high:
        return const Color(0xFFFEF2F2);
      case medium:
        return const Color(0xFFFFFBEB);
      case utility:
        return const Color(0xFFEFF6FF);
      case endgame:
        return const Color(0xFFF0FDF4);
    }
  }
}

class Mission {
  final String id;
  final String title;
  final String subtitle;
  final MissionPriority priority;

  const Mission({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.priority,
  });
}
