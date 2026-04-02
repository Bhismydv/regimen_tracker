import '../entities/habit.dart';

abstract class HabitRepository {
  Future<void> addHabit(Habit habit);
  Future<List<Habit>> getAllHabits();
}