import 'package:regimen_tracker/domain/entities/regimen_insight.dart';

sealed class InsightsState {
  const InsightsState();
}

class InsightsInitial extends InsightsState {
  const InsightsInitial();
}

class InsightsLoading extends InsightsState {
  const InsightsLoading();
}

class InsightsLoaded extends InsightsState {
  final InsightReport report;

  const InsightsLoaded(this.report);
}

class InsightsFailure extends InsightsState {
  final String message;

  const InsightsFailure(this.message);
}
