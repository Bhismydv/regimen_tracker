import '../enums/habit_category.dart';
import '../enums/measurement_type.dart';

class Habit {
  final String id;
  final String name;
  final HabitCategory category;
  final MeasurementType measurementType;
  final int intensityScaleMax;
  final bool isActive;
  final int colorValue;

  Habit({
    required this.id,
    required this.name,
    required this.category,
    required this.measurementType,
    required this.intensityScaleMax,
    required this.isActive,
    required this.colorValue
  });
}