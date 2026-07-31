import 'package:flutter/widgets.dart';

class TimelineStage {
  final String label;
  final IconData icon;
  final String timestamp;
  final String user;
  final String? notes;
  final bool isActive;
  final bool isCompleted;

  const TimelineStage({
    required this.label,
    required this.icon,
    required this.timestamp,
    required this.user,
    this.notes,
    this.isActive = false,
    this.isCompleted = false,
  });

  TimelineStage copyWith({
    String? timestamp,
    String? user,
    String? notes,
    bool? isActive,
    bool? isCompleted,
  }) {
    return TimelineStage(
      label: label,
      icon: icon,
      timestamp: timestamp ?? this.timestamp,
      user: user ?? this.user,
      notes: notes ?? this.notes,
      isActive: isActive ?? this.isActive,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}


