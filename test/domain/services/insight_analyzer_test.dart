import 'package:flutter_test/flutter_test.dart';
import 'package:regimen_tracker/domain/entities/daily_log.dart';
import 'package:regimen_tracker/domain/entities/habit.dart';
import 'package:regimen_tracker/domain/entities/habit_log_entry.dart';
import 'package:regimen_tracker/domain/entities/regimen_insight.dart';
import 'package:regimen_tracker/domain/entities/timeline_log.dart';
import 'package:regimen_tracker/domain/enums/habit_category.dart';
import 'package:regimen_tracker/domain/enums/measurement_type.dart';
import 'package:regimen_tracker/domain/services/insight_analyzer.dart';

void main() {
  const analyzer = InsightAnalyzer();
  final habit = Habit(
    id: 'scrub',
    name: 'Physical scrub',
    category: HabitCategory.exfoliation,
    measurementType: MeasurementType.binary,
    intensityScaleMax: 1,
    isActive: true,
    colorValue: 0xFFE57373,
  );

  test('requires a minimum history before calculating patterns', () {
    final logs = List.generate(4, (index) {
      final date = DateTime(2026, 9, index + 1);
      return TimelineLog(
        log: DailyLog(date: date, imagePath: '$index.jpg'),
        habitEntries: const [],
      );
    });

    final report = analyzer.analyze(logs: logs, habits: [habit]);
    expect(report.hasMinimumData, isFalse);
    expect(report.logsNeeded, 3);
    expect(report.insights, isEmpty);
  });

  test('finds the strongest known two-day delayed association', () {
    const usage = <int>[1, 0, 0, 1, 1, 0, 1, 0, 0, 0, 1, 0, 1, 1, 0, 0];
    final logs = List.generate(usage.length, (index) {
      final date = DateTime(2026, 8, index + 1);
      final irritation = index < 2 ? null : (usage[index - 2] == 1 ? 8.0 : 2.0);
      return TimelineLog(
        log: DailyLog(
          date: date,
          imagePath: '$index.jpg',
          irritationScore: irritation,
        ),
        habitEntries: usage[index] == 0
            ? const []
            : [
                HabitLogEntry(
                  id: 'entry-$index',
                  habitId: habit.id,
                  logDate: date,
                  value: 1,
                ),
              ],
      );
    });

    final report = analyzer.analyze(logs: logs, habits: [habit]);
    final association = report.insights.firstWhere(
      (insight) => insight.kind == InsightKind.habitAssociation,
    );
    expect(association.metric, OutcomeMetric.irritation);
    expect(association.lagDays, 2);
    expect(association.strength, closeTo(1, 0.001));
    expect(association.description, contains('does not prove causation'));
  });

  test('summarizes meaningful recent outcome changes', () {
    final logs = List.generate(14, (index) {
      return TimelineLog(
        log: DailyLog(
          date: DateTime(2026, 8, index + 1),
          imagePath: '$index.jpg',
          irritationScore: index < 7 ? 8 : 2,
        ),
        habitEntries: const [],
      );
    });

    final report = analyzer.analyze(logs: logs, habits: const []);
    final trend = report.insights.single;
    expect(trend.kind, InsightKind.outcomeTrend);
    expect(trend.title, contains('decreased'));
    expect(trend.description, contains('6.0 points lower'));
  });
}
