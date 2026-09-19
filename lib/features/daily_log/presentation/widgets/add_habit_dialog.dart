import 'package:flutter/material.dart';
import 'package:regimen_tracker/domain/entities/habit.dart';
import 'package:regimen_tracker/domain/enums/habit_category.dart';
import 'package:regimen_tracker/domain/enums/measurement_type.dart';

class AddHabitDialog extends StatefulWidget {
  const AddHabitDialog({super.key});

  @override
  State<AddHabitDialog> createState() => _AddHabitDialogState();
}

class _AddHabitDialogState extends State<AddHabitDialog> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  HabitCategory category = HabitCategory.treatment;
  MeasurementType measurementType = MeasurementType.binary;

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add a habit'),
      content: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                key: const Key('habit-name-field'),
                controller: nameController,
                autofocus: true,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Habit name',
                  hintText: 'Cold therapy',
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Enter a habit name'
                    : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<HabitCategory>(
                initialValue: category,
                decoration: const InputDecoration(labelText: 'Category'),
                items: HabitCategory.values
                    .map(
                      (value) => DropdownMenuItem(
                        value: value,
                        child: Text(_title(value.name)),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) setState(() => category = value);
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<MeasurementType>(
                initialValue: measurementType,
                decoration: const InputDecoration(labelText: 'Measurement'),
                items: MeasurementType.values
                    .map(
                      (value) => DropdownMenuItem(
                        value: value,
                        child: Text(_measurementLabel(value)),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) setState(() => measurementType = value);
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          key: const Key('confirm-add-habit-button'),
          onPressed: submit,
          child: const Text('Add'),
        ),
      ],
    );
  }

  void submit() {
    if (!formKey.currentState!.validate()) return;

    final timestamp = DateTime.now().microsecondsSinceEpoch;
    Navigator.pop(
      context,
      Habit(
        id: 'custom_$timestamp',
        name: nameController.text.trim(),
        category: category,
        measurementType: measurementType,
        intensityScaleMax: switch (measurementType) {
          MeasurementType.binary => 1,
          MeasurementType.scale => 10,
          MeasurementType.duration => 60,
        },
        isActive: true,
        colorValue: _habitColors[timestamp % _habitColors.length],
      ),
    );
  }

  String _measurementLabel(MeasurementType value) {
    return switch (value) {
      MeasurementType.binary => 'Yes / no',
      MeasurementType.scale => 'Intensity (0–10)',
      MeasurementType.duration => 'Duration (minutes)',
    };
  }

  String _title(String value) =>
      '${value[0].toUpperCase()}${value.substring(1)}';
}

const _habitColors = <int>[
  0xFF26A69A,
  0xFF42A5F5,
  0xFF7E57C2,
  0xFFEC407A,
  0xFFFFA726,
  0xFF66BB6A,
];
