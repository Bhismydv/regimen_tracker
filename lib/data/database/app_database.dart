import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'tables/habits_table.dart';
import 'tables/daily_logs_table.dart';
import 'tables/habit_log_entries_table.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [Habits, DailyLogs, HabitLogEntries],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

// Future migrations go here


}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'regimen.sqlite'));
    return NativeDatabase(file);
  });
}