import 'package:drift/drift.dart';

import '../../domain/entities/habit.dart' as domain;
import '../../domain/repositories/habit_repository.dart';
import '../database/app_database.dart' as db;
import '../mappers/enum_mappers.dart';

class HabitRepositoryImpl implements HabitRepository {
  final db.AppDatabase database;

  HabitRepositoryImpl(this.database);

  @override
  Future<void> addHabit(domain.Habit habit) async {
    await database.into(database.habits).insert(
      db.HabitsCompanion.insert(
        id: habit.id,
        name: habit.name,
        category: EnumMappers.habitCategoryToString(habit.category),
        measurementType: EnumMappers.measurementTypeToString(
            habit.measurementType),
        intensityScaleMax: habit.intensityScaleMax,
        isActive: Value(habit.isActive),
        colorValue: habit.colorValue,
      ),
    );
  }

  @override
  Future<List<domain.Habit>> getAllHabits() async {
    final rows = await database.select(database.habits).get();

    return rows.map((row) {
      return domain.Habit(
        id: row.id,
        name: row.name,
        category:
        EnumMappers.stringToHabitCategory(row.category),
        measurementType:
        EnumMappers.stringToMeasurementType(row.measurementType),
        intensityScaleMax: row.intensityScaleMax,
        isActive: row.isActive,
        colorValue: row.colorValue,
      );
    }).toList();
  }
}