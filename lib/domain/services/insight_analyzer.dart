import 'dart:math' as math;

import '../entities/habit.dart';
import '../entities/regimen_insight.dart';
import '../entities/timeline_log.dart';

class InsightAnalyzer {
  static const minimumPairs = 7;
  static const minimumGroupSize = 2;
  static const meaningfulCorrelation = 0.25;
  static const meaningfulTrendChange = 0.75;
  static const maximumLagDays = 3;

  const InsightAnalyzer();

  InsightReport analyze({
    required List<TimelineLog> logs,
    required List<Habit> habits,
  }) {
    final orderedLogs = [...logs]
      ..sort((a, b) => a.log.date.compareTo(b.log.date));
    final scoredLogCount = orderedLogs.where((entry) {
      return entry.log.irritationScore != null ||
          entry.log.oilinessScore != null;
    }).length;

    if (orderedLogs.length < InsightReport.minimumLogs) {
      return InsightReport(
        logCount: orderedLogs.length,
        scoredLogCount: scoredLogCount,
        insights: const [],
      );
    }

    final insights = <RegimenInsight>[
      ..._habitInsights(orderedLogs, habits),
      ..._trendInsights(orderedLogs),
    ]..sort((a, b) => b.strength.abs().compareTo(a.strength.abs()));

    return InsightReport(
      logCount: orderedLogs.length,
      scoredLogCount: scoredLogCount,
      insights: insights.take(6).toList(),
    );
  }

  List<RegimenInsight> _habitInsights(
    List<TimelineLog> logs,
    List<Habit> habits,
  ) {
    final logsByDate = {for (final entry in logs) _day(entry.log.date): entry};
    final results = <RegimenInsight>[];

    for (final habit in habits) {
      _AssociationCandidate? strongest;
      for (final metric in OutcomeMetric.values) {
        for (var lag = 0; lag <= maximumLagDays; lag++) {
          final candidate = _associationCandidate(
            logs: logs,
            logsByDate: logsByDate,
            habit: habit,
            metric: metric,
            lagDays: lag,
          );
          if (candidate == null) continue;
          if (strongest == null ||
              candidate.correlation.abs() > strongest.correlation.abs()) {
            strongest = candidate;
          }
        }
      }

      if (strongest != null &&
          strongest.correlation.abs() >= meaningfulCorrelation) {
        results.add(_associationInsight(strongest));
      }
    }
    return results;
  }

  _AssociationCandidate? _associationCandidate({
    required List<TimelineLog> logs,
    required Map<DateTime, TimelineLog> logsByDate,
    required Habit habit,
    required OutcomeMetric metric,
    required int lagDays,
  }) {
    final habitValues = <double>[];
    final outcomes = <double>[];

    for (final source in logs) {
      final outcomeDate = _day(source.log.date.add(Duration(days: lagDays)));
      final target = logsByDate[outcomeDate];
      if (target == null) continue;
      final outcome = _outcomeValue(target, metric);
      if (outcome == null) continue;

      habitValues.add(_habitValue(source, habit.id));
      outcomes.add(outcome);
    }

    if (habitValues.length < minimumPairs) return null;
    final usedOutcomes = <double>[];
    final unusedOutcomes = <double>[];
    for (var index = 0; index < habitValues.length; index++) {
      (habitValues[index] > 0 ? usedOutcomes : unusedOutcomes).add(
        outcomes[index],
      );
    }
    if (usedOutcomes.length < minimumGroupSize ||
        unusedOutcomes.length < minimumGroupSize) {
      return null;
    }

    final correlation = _pearson(habitValues, outcomes);
    if (correlation == null) return null;
    return _AssociationCandidate(
      habit: habit,
      metric: metric,
      lagDays: lagDays,
      correlation: correlation,
      sampleSize: outcomes.length,
      usedAverage: _average(usedOutcomes),
      unusedAverage: _average(unusedOutcomes),
    );
  }

  RegimenInsight _associationInsight(_AssociationCandidate candidate) {
    final metricName = _metricName(candidate.metric);
    final difference = candidate.usedAverage - candidate.unusedAverage;
    final direction = difference >= 0 ? 'higher' : 'lower';
    final lagText = candidate.lagDays == 0
        ? 'on the same day'
        : '${candidate.lagDays} day${candidate.lagDays == 1 ? '' : 's'} later';

    return RegimenInsight(
      kind: InsightKind.habitAssociation,
      title: '$metricName is associated with ${candidate.habit.name}',
      description:
          '$metricName averaged ${difference.abs().toStringAsFixed(1)} points '
          '$direction $lagText after ${candidate.habit.name.toLowerCase()} was '
          'logged. Based on ${candidate.sampleSize} paired days; association '
          'does not prove causation.',
      metric: candidate.metric,
      strength: candidate.correlation,
      sampleSize: candidate.sampleSize,
      habitId: candidate.habit.id,
      lagDays: candidate.lagDays,
    );
  }

  List<RegimenInsight> _trendInsights(List<TimelineLog> logs) {
    final results = <RegimenInsight>[];
    for (final metric in OutcomeMetric.values) {
      final values = logs
          .map((entry) => _outcomeValue(entry, metric))
          .whereType<double>()
          .toList();
      if (values.length < 6) continue;

      final recentCount = math.min(7, values.length ~/ 2);
      if (recentCount < 3) continue;
      final recent = values.sublist(values.length - recentCount);
      final previous = values.sublist(
        values.length - recentCount * 2,
        values.length - recentCount,
      );
      final change = _average(recent) - _average(previous);
      if (change.abs() < meaningfulTrendChange) continue;
      final metricName = _metricName(metric);
      final direction = change > 0 ? 'increased' : 'decreased';

      results.add(
        RegimenInsight(
          kind: InsightKind.outcomeTrend,
          title: '$metricName recently $direction',
          description:
              'The latest $recentCount scored logs average '
              '${change.abs().toStringAsFixed(1)} points '
              '${change > 0 ? 'higher' : 'lower'} than the previous '
              '$recentCount.',
          metric: metric,
          strength: change / 10,
          sampleSize: recentCount * 2,
        ),
      );
    }
    return results;
  }

  double _habitValue(TimelineLog log, String habitId) {
    for (final entry in log.habitEntries) {
      if (entry.habitId == habitId) return entry.value;
    }
    return 0;
  }

  double? _outcomeValue(TimelineLog log, OutcomeMetric metric) {
    return switch (metric) {
      OutcomeMetric.irritation => log.log.irritationScore,
      OutcomeMetric.oiliness => log.log.oilinessScore,
    };
  }

  double? _pearson(List<double> x, List<double> y) {
    final xMean = _average(x);
    final yMean = _average(y);
    var numerator = 0.0;
    var xSquares = 0.0;
    var ySquares = 0.0;
    for (var index = 0; index < x.length; index++) {
      final xDelta = x[index] - xMean;
      final yDelta = y[index] - yMean;
      numerator += xDelta * yDelta;
      xSquares += xDelta * xDelta;
      ySquares += yDelta * yDelta;
    }
    final denominator = math.sqrt(xSquares * ySquares);
    return denominator == 0 ? null : numerator / denominator;
  }

  double _average(List<double> values) =>
      values.reduce((a, b) => a + b) / values.length;

  DateTime _day(DateTime value) => DateTime(value.year, value.month, value.day);

  String _metricName(OutcomeMetric metric) => switch (metric) {
    OutcomeMetric.irritation => 'Irritation',
    OutcomeMetric.oiliness => 'Oiliness',
  };
}

class _AssociationCandidate {
  final Habit habit;
  final OutcomeMetric metric;
  final int lagDays;
  final double correlation;
  final int sampleSize;
  final double usedAverage;
  final double unusedAverage;

  const _AssociationCandidate({
    required this.habit,
    required this.metric,
    required this.lagDays,
    required this.correlation,
    required this.sampleSize,
    required this.usedAverage,
    required this.unusedAverage,
  });
}
