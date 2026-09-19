import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:regimen_tracker/domain/repositories/habit_repository.dart';
import 'package:regimen_tracker/domain/repositories/log_repository.dart';
import 'package:regimen_tracker/features/timeline/presentation/cubit/timeline_state.dart';
import 'package:regimen_tracker/features/timeline/presentation/widgets/timeline_item.dart';

class TimelineCubit extends Cubit<TimelineState> {
  final LogRepository logRepository;
  final HabitRepository habitRepository;

  TimelineCubit(this.logRepository, this.habitRepository)
    : super(const TimelineInitial());

  Future<void> loadTimeline() async {
    emit(const TimelineLoading());
    try {
      final timelineLogs = await logRepository.getTimelineLogs();
      if (timelineLogs.isEmpty) {
        emit(const TimelineEmpty());
        return;
      }

      final habits = (await habitRepository.getAllHabits())
          .where((habit) => habit.isActive)
          .toList();
      final usedHabitIds = timelineLogs
          .expand((log) => log.habitEntries)
          .map((entry) => entry.habitId)
          .toSet();
      final initiallyVisible = habits
          .where((habit) => usedHabitIds.contains(habit.id))
          .map((habit) => habit.id)
          .toSet();

      emit(
        TimelineLoaded(
          items: timelineLogs.map(TimelineItem.fromTimelineLog).toList(),
          habits: habits,
          visibleHabitIds: initiallyVisible,
        ),
      );
    } catch (error) {
      emit(TimelineFailure('Could not load the timeline: $error'));
    }
  }

  void toggleHabit(String habitId) {
    final current = state;
    if (current is! TimelineLoaded) return;

    final nextVisible = {...current.visibleHabitIds};
    if (!nextVisible.remove(habitId)) {
      nextVisible.add(habitId);
    }
    emit(current.copyWith(visibleHabitIds: nextVisible));
  }

  void toggleDate(DateTime date) {
    final current = state;
    if (current is! TimelineLoaded) return;

    final nextDates = [...current.selectedDates];
    final existingIndex = nextDates.indexOf(date);
    if (existingIndex >= 0) {
      nextDates.removeAt(existingIndex);
    } else {
      if (nextDates.length == 2) nextDates.removeAt(0);
      nextDates.add(date);
    }
    emit(current.copyWith(selectedDates: nextDates));
  }
}
