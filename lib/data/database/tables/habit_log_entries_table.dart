import 'package:drift/drift.dart';
import 'daily_logs_table.dart';
import 'habits_table.dart';

class HabitLogEntries extends Table {
  TextColumn get id => text()();

  TextColumn get habitId => text()
      .references(Habits, #id, onDelete: KeyAction.cascade)();

  DateTimeColumn get logDate => dateTime()
      .references(DailyLogs, #date, onDelete: KeyAction.cascade)();

  RealColumn get value => real()();

  @override
  Set<Column> get primaryKey => {id};
}