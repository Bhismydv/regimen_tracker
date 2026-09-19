import '../entities/daily_log.dart';
import '../entities/habit_log_entry.dart';
import '../entities/timeline_log.dart';

abstract class LogRepository {
  Future<void> addDailyLog(DailyLog log);
  Future<void> addHabitEntries(List<HabitLogEntry> entries);
  Future<void> saveDailyLogWithEntries(
    DailyLog log,
    List<HabitLogEntry> entries,
  );

  Future<DailyLog?> getLogByDate(DateTime date);
  Future<DailyLog?> getMostRecentLog();
  Future<List<DailyLog>> getLogs();
  Future<List<HabitLogEntry>> getEntriesByDate(DateTime date);
  Future<List<TimelineLog>> getTimelineLogs();
}
