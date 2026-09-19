import '../entities/habit.dart';
import '../enums/habit_category.dart';
import '../enums/measurement_type.dart';
import '../repositories/habit_repository.dart';

const defaultHabits = <Habit>[
  Habit(
    id: 'physical_scrub',
    name: 'Physical scrub',
    category: HabitCategory.exfoliation,
    measurementType: MeasurementType.binary,
    intensityScaleMax: 1,
    isActive: true,
    colorValue: 0xFFE57373,
  ),
  Habit(
    id: 'chemical_exfoliant',
    name: 'Chemical exfoliant',
    category: HabitCategory.exfoliation,
    measurementType: MeasurementType.binary,
    intensityScaleMax: 1,
    isActive: true,
    colorValue: 0xFFFF8A65,
  ),
  Habit(
    id: 'cold_therapy',
    name: 'Cold therapy',
    category: HabitCategory.lifestyle,
    measurementType: MeasurementType.duration,
    intensityScaleMax: 60,
    isActive: true,
    colorValue: 0xFF42A5F5,
  ),
  Habit(
    id: 'product_layering',
    name: 'Product layering',
    category: HabitCategory.hydration,
    measurementType: MeasurementType.scale,
    intensityScaleMax: 10,
    isActive: true,
    colorValue: 0xFF7E57C2,
  ),
  Habit(
    id: 'retinol',
    name: 'Retinol',
    category: HabitCategory.treatment,
    measurementType: MeasurementType.binary,
    intensityScaleMax: 1,
    isActive: true,
    colorValue: 0xFFAB47BC,
  ),
];

Future<List<Habit>> ensureDefaultHabits(HabitRepository repository) async {
  var habits = await repository.getAllHabits();
  final existingIds = habits.map((habit) => habit.id).toSet();
  final existingNames = habits
      .map((habit) => habit.name.trim().toLowerCase())
      .toSet();

  for (final habit in defaultHabits) {
    if (existingIds.contains(habit.id) ||
        existingNames.contains(habit.name.toLowerCase())) {
      continue;
    }
    await repository.addHabit(habit);
  }
  habits = await repository.getAllHabits();
  return habits;
}
