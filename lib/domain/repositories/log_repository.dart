import '../entities/daily_log.dart';
import '../entities/habit_log_entry.dart';

abstract class LogRepository {
  Future<void> addDailyLog(DailyLog log);
  Future<void> addHabitEntries(List<HabitLogEntry> entries);

  Future<DailyLog?> getLogByDate(DateTime date);
  Future<List<DailyLog>> getLogs();
  Future<List<HabitLogEntry>> getEntriesByDate(DateTime date);
}