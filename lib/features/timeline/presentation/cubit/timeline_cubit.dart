import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:regimen_tracker/data/repositories/habit_repository_impl.dart';
import 'package:regimen_tracker/data/repositories/log_repository_impl.dart';
import 'package:regimen_tracker/features/timeline/presentation/widgets/timeline_item.dart';

class TimelineCubit extends Cubit<List<TimelineItem>> {
  final LogRepositoryImpl logRepository;
  final HabitRepositoryImpl habitRepository;

  TimelineCubit(this.logRepository, this.habitRepository) : super([]);

  Future<void> loadTimeline() async {
    final logs = await logRepository.getLogs();
    logs.sort((a, b) => a.date.compareTo(b.date));

    // ✅ load once
    final habits = await habitRepository.getAllHabits();
    final habitMap = { for (var h in habits) h.id: h };

    List<TimelineItem> items = [];

    for (final log in logs) {
      final entries =
      await logRepository.getEntriesByDate(log.date);

      items.add(
        TimelineItem(
          date: log.date,
          imagePath: log.imagePath,
          thumbnailPath: log.thumbnailPath,
          habits: entries,
          habitMap: habitMap,
        ),
      );
    }

    emit(items);
  }
}