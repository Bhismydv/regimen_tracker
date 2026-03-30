import 'package:drift/drift.dart';

class Habits extends Table {
  TextColumn get id => text()(); // UUID

  TextColumn get name => text()();

  // Store enum as TEXT (safe & readable)
  TextColumn get category => text()();

  TextColumn get measurementType => text()();

  IntColumn get intensityScaleMax => integer()();

  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}