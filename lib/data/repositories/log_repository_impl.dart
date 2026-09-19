import 'package:drift/drift.dart';

import '../../domain/entities/daily_log.dart';
import '../../domain/entities/habit_log_entry.dart';
import '../../domain/entities/timeline_log.dart';
import '../../domain/repositories/log_repository.dart';
import '../database/app_database.dart' as db;
import '../mappers/enum_mappers.dart';

class LogRepositoryImpl implements LogRepository {
  final db.AppDatabase database;

  LogRepositoryImpl(this.database);

  @override
  Future<void> addDailyLog(DailyLog log) async {
    await database
        .into(database.dailyLogs)
        .insertOnConflictUpdate(_dailyLogCompanion(log));
  }

  @override
  Future<void> addHabitEntries(List<HabitLogEntry> entries) async {
    if (entries.isEmpty) return;

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
  Future<void> saveDailyLogWithEntries(
    DailyLog log,
    List<HabitLogEntry> entries,
  ) async {
    await database.transaction(() async {
      await (database.delete(
        database.habitLogEntries,
      )..where((entry) => entry.logDate.equals(log.date))).go();
      await database
          .into(database.dailyLogs)
          .insertOnConflictUpdate(_dailyLogCompanion(log));
      await addHabitEntries(entries);
    });
  }

  @override
  Future<DailyLog?> getLogByDate(DateTime date) async {
    final query = await (database.select(
      database.dailyLogs,
    )..where((tbl) => tbl.date.equals(date))).getSingleOrNull();

    if (query == null) return null;

    return _mapDailyLog(query);
  }

  @override
  Future<DailyLog?> getMostRecentLog() async {
    final row =
        await (database.select(database.dailyLogs)
              ..orderBy([(log) => OrderingTerm.desc(log.date)])
              ..limit(1))
            .getSingleOrNull();

    return row == null ? null : _mapDailyLog(row);
  }

  @override
  Future<List<DailyLog>> getLogs() async {
    final rows = await database.select(database.dailyLogs).get();

    return rows.map(_mapDailyLog).toList();
  }

  @override
  Future<List<HabitLogEntry>> getEntriesByDate(DateTime date) async {
    final rows = await (database.select(
      database.habitLogEntries,
    )..where((tbl) => tbl.logDate.equals(date))).get();

    return rows.map((row) {
      return HabitLogEntry(
        id: row.id,
        habitId: row.habitId,
        logDate: row.logDate,
        value: row.value,
      );
    }).toList();
  }

  @override
  Future<List<TimelineLog>> getTimelineLogs() async {
    final query = database.select(database.dailyLogs).join([
      leftOuterJoin(
        database.habitLogEntries,
        database.habitLogEntries.logDate.equalsExp(database.dailyLogs.date),
      ),
    ])..orderBy([OrderingTerm.asc(database.dailyLogs.date)]);
    final rows = await query.get();
    final logsByDate = <DateTime, DailyLog>{};
    final entriesByDate = <DateTime, List<HabitLogEntry>>{};

    for (final row in rows) {
      final logRow = row.readTable(database.dailyLogs);
      final entryRow = row.readTableOrNull(database.habitLogEntries);
      logsByDate.putIfAbsent(logRow.date, () => _mapDailyLog(logRow));
      final entries = entriesByDate.putIfAbsent(logRow.date, () => []);
      if (entryRow != null) {
        entries.add(
          HabitLogEntry(
            id: entryRow.id,
            habitId: entryRow.habitId,
            logDate: entryRow.logDate,
            value: entryRow.value,
          ),
        );
      }
    }

    return logsByDate.entries.map((entry) {
      return TimelineLog(
        log: entry.value,
        habitEntries: entriesByDate[entry.key] ?? const [],
      );
    }).toList();
  }

  db.DailyLogsCompanion _dailyLogCompanion(DailyLog log) {
    return db.DailyLogsCompanion.insert(
      date: log.date,
      imagePath: log.imagePath,
      thumbnailPath: Value(log.thumbnailPath),
      notes: Value(log.notes),
      conditionTag: Value(EnumMappers.skinTagToString(log.conditionTag)),
      irritationScore: Value(log.irritationScore),
      oilinessScore: Value(log.oilinessScore),
    );
  }

  DailyLog _mapDailyLog(db.DailyLog row) {
    return DailyLog(
      date: row.date,
      imagePath: row.imagePath,
      thumbnailPath: row.thumbnailPath,
      notes: row.notes,
      conditionTag: EnumMappers.stringToSkinTag(row.conditionTag),
      irritationScore: row.irritationScore,
      oilinessScore: row.oilinessScore,
    );
  }
}
