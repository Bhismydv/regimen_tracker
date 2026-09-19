import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'tables/habits_table.dart';
import 'tables/daily_logs_table.dart';
import 'tables/habit_log_entries_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Habits, DailyLogs, HabitLogEntries])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) => migrator.createAll(),
    onUpgrade: (migrator, from, to) async {
      // Add explicit, sequential migration calls here before increasing
      // schemaVersion. Failing closed prevents incompatible databases from
      // being opened silently in a release build.
      if (from != to) {
        throw StateError('Missing database migration from $from to $to');
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'regimen.sqlite'));
    return NativeDatabase(file);
  });
}
