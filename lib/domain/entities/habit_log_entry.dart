class HabitLogEntry {
  final String id;
  final String habitId;
  final DateTime logDate;
  final double value;

  HabitLogEntry({
    required this.id,
    required this.habitId,
    required this.logDate,
    required this.value,
  });
}