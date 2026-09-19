enum InsightKind { habitAssociation, outcomeTrend }

enum OutcomeMetric { irritation, oiliness }

class RegimenInsight {
  final InsightKind kind;
  final String title;
  final String description;
  final OutcomeMetric metric;
  final double strength;
  final int sampleSize;
  final String? habitId;
  final int? lagDays;

  const RegimenInsight({
    required this.kind,
    required this.title,
    required this.description,
    required this.metric,
    required this.strength,
    required this.sampleSize,
    this.habitId,
    this.lagDays,
  });
}

class InsightReport {
  static const minimumLogs = 7;

  final int logCount;
  final int scoredLogCount;
  final List<RegimenInsight> insights;

  const InsightReport({
    required this.logCount,
    required this.scoredLogCount,
    required this.insights,
  });

  bool get hasMinimumData => logCount >= minimumLogs;
  int get logsNeeded =>
      hasMinimumData ? 0 : InsightReport.minimumLogs - logCount;
}
