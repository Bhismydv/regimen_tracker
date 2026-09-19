import '../../../../domain/entities/habit_log_entry.dart';
import '../../../../domain/entities/timeline_log.dart';

class TimelineItem {
  final DateTime date;
  final String imagePath;
  final String? thumbnailPath;
  final List<HabitLogEntry> habitEntries;
  final double? irritationScore;
  final double? oilinessScore;

  const TimelineItem({
    required this.date,
    required this.imagePath,
    this.thumbnailPath,
    required this.habitEntries,
    this.irritationScore,
    this.oilinessScore,
  });

  factory TimelineItem.fromTimelineLog(TimelineLog timelineLog) {
    final log = timelineLog.log;
    return TimelineItem(
      date: log.date,
      imagePath: log.imagePath,
      thumbnailPath: log.thumbnailPath,
      habitEntries: timelineLog.habitEntries,
      irritationScore: log.irritationScore,
      oilinessScore: log.oilinessScore,
    );
  }

  double? valueForHabit(String habitId) {
    for (final entry in habitEntries) {
      if (entry.habitId == habitId) return entry.value;
    }
    return null;
  }
}
