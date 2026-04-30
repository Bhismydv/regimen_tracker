import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:regimen_tracker/data/repositories/log_repository_impl.dart';
import 'package:regimen_tracker/features/timeline/presentation/widgets/timeline_item.dart';

class TimelineCubit extends Cubit<List<TimelineItem>> {
  final LogRepositoryImpl logRepository;

  TimelineCubit(this.logRepository) : super([]);

  Future<void> loadTimeline() async {
    final logs = await logRepository.getLogs();
    print("--------LOG COUNT: ${logs.length}");
    logs.sort((a, b) => a.date.compareTo(b.date));

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
        ),
      );
    }

    emit(items);
  }
}