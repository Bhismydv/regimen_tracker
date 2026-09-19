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
import 'package:regimen_tracker/domain/enums/skin_condition_tag.dart';

void main() {
  late AppDatabase database;
  late LogRepositoryImpl logRepository;
  late HabitRepositoryImpl habitRepository;

  setUp(() {
    database = AppDatabase.forTesting(
      NativeDatabase.memory(
        setup: (database) => database.execute('PRAGMA foreign_keys = ON'),
      ),
    );
    logRepository = LogRepositoryImpl(database);
    habitRepository = HabitRepositoryImpl(database);
  });

  tearDown(() => database.close());

  test(
    'same-day save atomically replaces log details and habit entries',
    () async {
      const habitId = 'exfoliation';
      await habitRepository.addHabit(
        domain.Habit(
          id: habitId,
          name: 'Exfoliation',
          category: HabitCategory.exfoliation,
          measurementType: MeasurementType.scale,
          intensityScaleMax: 10,
          isActive: true,
          colorValue: 0xFFE57373,
        ),
      );
      final date = DateTime(2026, 9, 19);

      await logRepository.saveDailyLogWithEntries(
        domain.DailyLog(
          date: date,
          imagePath: 'first.jpg',
          thumbnailPath: 'first_thumb.jpg',
        ),
        [
          HabitLogEntry(
            id: 'first-entry',
            habitId: habitId,
            logDate: date,
            value: 3,
          ),
        ],
      );
      await logRepository.saveDailyLogWithEntries(
        domain.DailyLog(
          date: date,
          imagePath: 'second.jpg',
          thumbnailPath: 'second_thumb.jpg',
          notes: 'Skin felt warm',
          conditionTag: SkinConditionTag.irritated,
          irritationScore: 7,
          oilinessScore: 2,
        ),
        [
          HabitLogEntry(
            id: 'second-entry',
            habitId: habitId,
            logDate: date,
            value: 7,
          ),
        ],
      );

      final savedLog = await logRepository.getLogByDate(date);
      final savedEntries = await logRepository.getEntriesByDate(date);
      expect(savedLog!.imagePath, 'second.jpg');
      expect(savedLog.notes, 'Skin felt warm');
      expect(savedLog.conditionTag, SkinConditionTag.irritated);
      expect(savedLog.irritationScore, 7);
      expect(savedLog.oilinessScore, 2);
      expect(savedEntries, hasLength(1));
      expect(savedEntries.single.value, 7);

      final timeline = await logRepository.getTimelineLogs();
      expect(timeline, hasLength(1));
      expect(timeline.single.log.imagePath, 'second.jpg');
      expect(timeline.single.habitEntries.single.value, 7);
    },
  );

  test('most recent query orders by date instead of insertion order', () async {
    final recentDate = DateTime(2026, 9, 19);
    final olderDate = DateTime(2026, 9, 18);

    await logRepository.addDailyLog(
      domain.DailyLog(date: recentDate, imagePath: 'recent.jpg'),
    );
    await logRepository.addDailyLog(
      domain.DailyLog(date: olderDate, imagePath: 'older.jpg'),
    );

    final result = await logRepository.getMostRecentLog();
    expect(result!.date, recentDate);
  });
}
