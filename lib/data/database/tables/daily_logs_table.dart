
import 'package:drift/drift.dart';

class DailyLogs extends Table {
  // Use date as primary key (1 log per day)
  DateTimeColumn get date => dateTime()();

  TextColumn get imagePath => text()();

  TextColumn get thumbnailPath => text().nullable()();

  TextColumn get notes => text().nullable()();

  TextColumn get conditionTag => text().nullable()();

  RealColumn get irritationScore => real().nullable()();

  RealColumn get oilinessScore => real().nullable()();

  @override
  Set<Column> get primaryKey => {date};
}