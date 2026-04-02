import 'package:drift/drift.dart';

import '../../domain/entities/daily_log.dart';
import '../../domain/entities/habit_log_entry.dart';
import '../../domain/repositories/log_repository.dart';
import '../database/app_database.dart' as db;
import '../mappers/enum_mappers.dart';

class LogRepositoryImpl implements LogRepository {
  final db.AppDatabase database;

  LogRepositoryImpl(this.database);

  @override
  Future<void> addDailyLog(DailyLog log) async {
    await database.into(database.dailyLogs).insert(
      db.DailyLogsCompanion.insert(
        date: log.date,
        imagePath: log.imagePath,
        thumbnailPath: Value(log.thumbnailPath),
        notes: Value(log.notes),
        conditionTag:
        Value(EnumMappers.skinTagToString(log.conditionTag)),
        irritationScore: Value(log.irritationScore),
        oilinessScore: Value(log.oilinessScore),
      ),
    );
  }

  @override
  Future<void> addHabitEntries(List<HabitLogEntry> entries) async {
    await database.batch((batch) {
      batch.insertAll(
        database.habitLogEntries,
        entries.map((e) {
          return db.HabitLogEntriesCompanion.insert(
            id: e.id,
            habitId: e.habitId,
            logDate: e.logDate,
            value: e.value,
          );
        }).toList(),
      );
    });
  }

  @override
  Future<DailyLog?> getLogByDate(DateTime date) async {
    final query = await (database.select(database.dailyLogs)
      ..where((tbl) => tbl.date.equals(date)))
        .getSingleOrNull();

    if (query == null) return null;

    return DailyLog(
      date: query.date,
      imagePath: query.imagePath,
      thumbnailPath: query.thumbnailPath,
      notes: query.notes,
      conditionTag:
      EnumMappers.stringToSkinTag(query.conditionTag),
      irritationScore: query.irritationScore,
      oilinessScore: query.oilinessScore,
    );
  }

  @override
  Future<List<DailyLog>> getLogs() async {
    final rows = await database.select(database.dailyLogs).get();

    return rows.map((row) {
      return DailyLog(
        date: row.date,
        imagePath: row.imagePath,
        thumbnailPath: row.thumbnailPath,
        notes: row.notes,
        conditionTag:
        EnumMappers.stringToSkinTag(row.conditionTag),
        irritationScore: row.irritationScore,
        oilinessScore: row.oilinessScore,
      );
    }).toList();
  }
}