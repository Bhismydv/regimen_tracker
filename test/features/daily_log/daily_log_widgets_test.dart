import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:regimen_tracker/domain/entities/habit.dart';
import 'package:regimen_tracker/domain/enums/habit_category.dart';
import 'package:regimen_tracker/domain/enums/measurement_type.dart';
import 'package:regimen_tracker/features/daily_log/presentation/widgets/add_habit_dialog.dart';
import 'package:regimen_tracker/features/daily_log/presentation/widgets/habit_tile.dart';
import 'package:regimen_tracker/features/daily_log/presentation/widgets/intensity_slider.dart';

void main() {
  testWidgets('binary habit emits its selected value', (tester) async {
    double? selectedValue;
    final habit = Habit(
      id: 'scrub',
      name: 'Physical scrub',
      category: HabitCategory.exfoliation,
      measurementType: MeasurementType.binary,
      intensityScaleMax: 1,
      isActive: true,
      colorValue: 0xFFE57373,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: HabitTile(
            habit: habit,
            value: selectedValue,
            onChanged: (value) => selectedValue = value,
          ),
        ),
      ),
    );

    await tester.tap(find.byType(Switch));
    expect(selectedValue, 1);
  });

  testWidgets('duration habit exposes minute-based range', (tester) async {
    final habit = Habit(
      id: 'cold',
      name: 'Cold therapy',
      category: HabitCategory.lifestyle,
      measurementType: MeasurementType.duration,
      intensityScaleMax: 60,
      isActive: true,
      colorValue: 0xFF42A5F5,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: HabitTile(habit: habit, value: 15, onChanged: (_) {}),
        ),
      ),
    );

    final slider = tester.widget<Slider>(find.byType(Slider));
    expect(slider.max, 60);
    expect(slider.divisions, 60);
    expect(find.text('15 min'), findsOneWidget);
  });

  testWidgets('outcome score can be added and cleared', (tester) async {
    double? score;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) => OutcomeScoreSlider(
              label: 'Irritation',
              icon: Icons.local_fire_department_outlined,
              value: score,
              onChanged: (value) => setState(() => score = value),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Add score'));
    await tester.pump();
    expect(find.byType(Slider), findsOneWidget);

    await tester.tap(find.byTooltip('Clear Irritation'));
    await tester.pump();
    expect(score, isNull);
    expect(find.text('Add score'), findsOneWidget);
  });

  testWidgets('custom habit dialog validates and returns a habit', (
    tester,
  ) async {
    Habit? createdHabit;

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () async {
              createdHabit = await showDialog<Habit>(
                context: context,
                builder: (_) => const AddHabitDialog(),
              );
            },
            child: const Text('Open'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('confirm-add-habit-button')));
    await tester.pump();
    expect(find.text('Enter a habit name'), findsOneWidget);

    await tester.enterText(
      find.byKey(const Key('habit-name-field')),
      'Ice roller',
    );
    await tester.tap(find.byKey(const Key('confirm-add-habit-button')));
    await tester.pumpAndSettle();

    expect(createdHabit?.name, 'Ice roller');
    expect(createdHabit?.measurementType, MeasurementType.binary);
  });
}
