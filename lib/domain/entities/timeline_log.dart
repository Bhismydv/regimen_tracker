import 'daily_log.dart';
import 'habit_log_entry.dart';

class TimelineLog {
  final DailyLog log;
  final List<HabitLogEntry> habitEntries;

  const TimelineLog({required this.log, required this.habitEntries});
}
