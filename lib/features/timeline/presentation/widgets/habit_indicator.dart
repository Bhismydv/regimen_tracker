import 'package:flutter/material.dart';
import 'package:regimen_tracker/domain/entities/habit.dart';

class HabitIndicator extends StatelessWidget {
  final Habit habit;
  final bool selected;
  final VoidCallback onSelected;

  const HabitIndicator({
    super.key,
    required this.habit,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      selected: selected,
      onSelected: (_) => onSelected(),
      avatar: CircleAvatar(backgroundColor: Color(habit.colorValue)),
      label: Text(habit.name),
    );
  }
}
