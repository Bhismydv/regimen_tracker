import 'package:flutter/material.dart';
import 'package:regimen_tracker/domain/entities/habit.dart';
import 'package:regimen_tracker/domain/enums/measurement_type.dart';

class HabitTile extends StatelessWidget {
  final Habit habit;
  final double? value;
  final ValueChanged<double?> onChanged;

  const HabitTile({
    super.key,
    required this.habit,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 12, 10),
        child: switch (habit.measurementType) {
          MeasurementType.binary => _buildBinary(),
          MeasurementType.scale => _buildSlider('Intensity', ''),
          MeasurementType.duration => _buildSlider('Duration', ' min'),
        },
      ),
    );
  }

  Widget _buildBinary() {
    final enabled = value == 1;
    return Row(
      children: [
        _colorMarker(),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(habit.name),
              Text(
                habit.category.name,
                style: const TextStyle(color: Colors.black54),
              ),
            ],
          ),
        ),
        Switch(
          value: enabled,
          onChanged: (isEnabled) => onChanged(isEnabled ? 1 : null),
        ),
      ],
    );
  }

  Widget _buildSlider(String measurementLabel, String suffix) {
    final steps = habit.intensityScaleMax < 1 ? 1 : habit.intensityScaleMax;
    final maximum = steps.toDouble();
    final currentValue = (value ?? 0).clamp(0, maximum).toDouble();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _colorMarker(),
            const SizedBox(width: 12),
            Expanded(child: Text(habit.name)),
            Text('${currentValue.round()}$suffix'),
          ],
        ),
        Text(
          '${habit.category.name} · $measurementLabel',
          style: const TextStyle(color: Colors.black54),
        ),
        Slider(
          value: currentValue,
          min: 0,
          max: maximum,
          divisions: steps,
          label: '${currentValue.round()}$suffix',
          onChanged: (nextValue) =>
              onChanged(nextValue == 0 ? null : nextValue),
        ),
      ],
    );
  }

  Widget _colorMarker() {
    return Container(
      width: 10,
      height: 36,
      decoration: BoxDecoration(
        color: Color(habit.colorValue),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
