import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:regimen_tracker/domain/repositories/habit_repository.dart';
import 'package:regimen_tracker/domain/repositories/log_repository.dart';
import 'package:regimen_tracker/domain/services/insight_analyzer.dart';
import 'package:regimen_tracker/features/insights/presentation/cubit/insights_state.dart';

class InsightsCubit extends Cubit<InsightsState> {
  final LogRepository logRepository;
  final HabitRepository habitRepository;
  final InsightAnalyzer analyzer;

  InsightsCubit(
    this.logRepository,
    this.habitRepository, {
    this.analyzer = const InsightAnalyzer(),
  }) : super(const InsightsInitial());

  Future<void> loadInsights() async {
    emit(const InsightsLoading());
    try {
      final logs = await logRepository.getTimelineLogs();
      final habits = await habitRepository.getAllHabits();
      emit(InsightsLoaded(analyzer.analyze(logs: logs, habits: habits)));
    } catch (error) {
      emit(InsightsFailure('Could not calculate insights: $error'));
    }
  }
}
