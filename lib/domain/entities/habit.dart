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

  const Habit({
    required this.id,
    required this.name,
    required this.category,
    required this.measurementType,
    required this.intensityScaleMax,
    required this.isActive,
    required this.colorValue,
  });

  Habit copyWith({
    String? name,
    HabitCategory? category,
    MeasurementType? measurementType,
    int? intensityScaleMax,
    bool? isActive,
    int? colorValue,
  }) {
    return Habit(
      id: id,
      name: name ?? this.name,
      category: category ?? this.category,
      measurementType: measurementType ?? this.measurementType,
      intensityScaleMax: intensityScaleMax ?? this.intensityScaleMax,
      isActive: isActive ?? this.isActive,
      colorValue: colorValue ?? this.colorValue,
    );
  }
}
