

import '../../../../domain/entities/habit_log_entry.dart';

class TimelineItem {
  final DateTime date;
  final String imagePath;
  final String? thumbnailPath;
  final List<HabitLogEntry> habits;

  TimelineItem({
    required this.date,
    required this.imagePath,
    this.thumbnailPath,
    required this.habits,
  });
}