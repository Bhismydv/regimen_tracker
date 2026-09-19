import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:regimen_tracker/domain/entities/habit.dart';
import 'package:regimen_tracker/domain/enums/habit_category.dart';
import 'package:regimen_tracker/domain/enums/measurement_type.dart';
import 'package:regimen_tracker/features/comparison/presentation/widgets/image_comparison_slider.dart';
import 'package:regimen_tracker/features/timeline/presentation/widgets/timeline_image.dart';
import 'package:regimen_tracker/features/timeline/presentation/widgets/timeline_item.dart';

void main() {
  testWidgets('timeline thumbnail emits its date selection', (tester) async {
    final date = DateTime(2026, 9, 19);
    DateTime? selectedDate;
    final habit = Habit(
      id: 'retinol',
      name: 'Retinol',
      category: HabitCategory.treatment,
      measurementType: MeasurementType.binary,
      intensityScaleMax: 1,
      isActive: true,
      colorValue: 0xFFAB47BC,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TimelineChart(
            items: [
              TimelineItem(
                date: date,
                imagePath: 'missing.jpg',
                habitEntries: const [],
                irritationScore: 4,
              ),
            ],
            visibleHabits: [habit],
            selectedDates: const [],
            onDateSelected: (value) => selectedDate = value,
          ),
        ),
      ),
    );

    await tester.tap(
      find.byKey(ValueKey('timeline-date-${date.toIso8601String()}')),
    );
    expect(selectedDate, date);
  });

  testWidgets('comparison slider follows horizontal input', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox.square(
              dimension: 300,
              child: ImageComparisonSlider(
                beforeImagePath: 'missing-before.jpg',
                afterImagePath: 'missing-after.jpg',
              ),
            ),
          ),
        ),
      ),
    );

    Align reveal() =>
        tester.widget<Align>(find.byKey(const Key('before-image-reveal')));

    expect(reveal().widthFactor, 0.5);
    final slider = find.byKey(const Key('image-comparison-slider'));
    final topLeft = tester.getTopLeft(slider);
    await tester.tapAt(topLeft + const Offset(240, 150));
    await tester.pump();
    expect(reveal().widthFactor, closeTo(0.8, 0.02));
  });
}
