import 'package:regimen_tracker/domain/entities/habit.dart';
import 'package:regimen_tracker/features/timeline/presentation/widgets/timeline_item.dart';

sealed class TimelineState {
  const TimelineState();
}

class TimelineInitial extends TimelineState {
  const TimelineInitial();
}

class TimelineLoading extends TimelineState {
  const TimelineLoading();
}

class TimelineEmpty extends TimelineState {
  const TimelineEmpty();
}

class TimelineFailure extends TimelineState {
  final String message;

  const TimelineFailure(this.message);
}

class TimelineLoaded extends TimelineState {
  final List<TimelineItem> items;
  final List<Habit> habits;
  final Set<String> visibleHabitIds;
  final List<DateTime> selectedDates;

  const TimelineLoaded({
    required this.items,
    required this.habits,
    required this.visibleHabitIds,
    this.selectedDates = const [],
  });

  TimelineLoaded copyWith({
    Set<String>? visibleHabitIds,
    List<DateTime>? selectedDates,
  }) {
    return TimelineLoaded(
      items: items,
      habits: habits,
      visibleHabitIds: visibleHabitIds ?? this.visibleHabitIds,
      selectedDates: selectedDates ?? this.selectedDates,
    );
  }
}
