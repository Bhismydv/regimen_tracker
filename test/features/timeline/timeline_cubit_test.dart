import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:regimen_tracker/data/database/app_database.dart'
    show AppDatabase;
import 'package:regimen_tracker/data/repositories/habit_repository_impl.dart';
import 'package:regimen_tracker/data/repositories/log_repository_impl.dart';
import 'package:regimen_tracker/domain/entities/daily_log.dart' as domain;
import 'package:regimen_tracker/domain/entities/habit.dart' as domain;
import 'package:regimen_tracker/domain/entities/habit_log_entry.dart';
import 'package:regimen_tracker/domain/enums/habit_category.dart';
import 'package:regimen_tracker/domain/enums/measurement_type.dart';
import 'package:regimen_tracker/features/timeline/presentation/cubit/timeline_cubit.dart';
import 'package:regimen_tracker/features/timeline/presentation/cubit/timeline_state.dart';

void main() {
  late AppDatabase database;
  late LogRepositoryImpl logRepository;
  late HabitRepositoryImpl habitRepository;
  late TimelineCubit cubit;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    logRepository = LogRepositoryImpl(database);
    habitRepository = HabitRepositoryImpl(database);
    cubit = TimelineCubit(logRepository, habitRepository);
  });

  tearDown(() async {
    await cubit.close();
    await database.close();
  });

  test('loads joined timeline and keeps the two newest selections', () async {
    const habitId = 'cold';
    await habitRepository.addHabit(
      domain.Habit(
        id: habitId,
        name: 'Cold therapy',
        category: HabitCategory.lifestyle,
        measurementType: MeasurementType.duration,
        intensityScaleMax: 60,
        isActive: true,
        colorValue: 0xFF42A5F5,
      ),
    );
    final dates = [
      DateTime(2026, 9, 17),
      DateTime(2026, 9, 18),
      DateTime(2026, 9, 19),
    ];
    for (final date in dates) {
      await logRepository.saveDailyLogWithEntries(
        domain.DailyLog(date: date, imagePath: '${date.day}.jpg'),
        [
          HabitLogEntry(
            id: 'entry-${date.day}',
            habitId: habitId,
            logDate: date,
            value: date.day.toDouble(),
          ),
        ],
      );
    }

    await cubit.loadTimeline();
    final loaded = cubit.state as TimelineLoaded;
    expect(loaded.items, hasLength(3));
    expect(loaded.visibleHabitIds, contains(habitId));

    for (final date in dates) {
      cubit.toggleDate(date);
    }
    final selected = cubit.state as TimelineLoaded;
    expect(selected.selectedDates, [dates[1], dates[2]]);

    cubit.toggleHabit(habitId);
    expect((cubit.state as TimelineLoaded).visibleHabitIds, isEmpty);
  });
}
