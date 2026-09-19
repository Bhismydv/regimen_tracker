import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:regimen_tracker/app/app.dart';
import 'package:regimen_tracker/app/di/app_container.dart';
import 'package:regimen_tracker/data/database/app_database.dart'
    show AppDatabase;
import 'package:regimen_tracker/domain/services/default_habits.dart';
import 'package:regimen_tracker/domain/entities/habit.dart';
import 'package:regimen_tracker/domain/enums/habit_category.dart';
import 'package:regimen_tracker/domain/enums/measurement_type.dart';
import 'package:regimen_tracker/features/habits/presentation/pages/habits_page.dart';

void main() {
  late AppDatabase database;
  late AppContainer container;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    container = AppContainer(database: database);
  });

  tearDown(() => container.dispose());

  test('default habit seeding is idempotent and updates persist', () async {
    final first = await ensureDefaultHabits(container.habitRepository);
    final second = await ensureDefaultHabits(container.habitRepository);
    expect(first, hasLength(defaultHabits.length));
    expect(second, hasLength(defaultHabits.length));

    final habit = first.first;
    await container.habitRepository.updateHabit(
      habit.copyWith(name: 'Renamed habit', isActive: false),
    );
    final stored = await container.habitRepository.getAllHabits();
    final updated = stored.singleWhere((item) => item.id == habit.id);
    expect(updated.name, 'Renamed habit');
    expect(updated.isActive, isFalse);
  });

  test('default seeding preserves equivalent legacy habits', () async {
    await container.habitRepository.addHabit(
      const Habit(
        id: 'legacy-retinol',
        name: 'Retinol',
        category: HabitCategory.treatment,
        measurementType: MeasurementType.scale,
        intensityScaleMax: 10,
        isActive: true,
        colorValue: 0xFFAB47BC,
      ),
    );

    final habits = await ensureDefaultHabits(container.habitRepository);
    expect(
      habits.where((habit) => habit.name.toLowerCase() == 'retinol'),
      hasLength(1),
    );
    expect(habits, hasLength(defaultHabits.length));
  });

  testWidgets('habit manager archives without deleting history', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(home: HabitsPage(container: container)),
    );
    await tester.pumpAndSettle();

    expect(find.byType(Switch), findsNWidgets(defaultHabits.length));
    await tester.tap(find.byType(Switch).first);
    await tester.pumpAndSettle();

    final stored = await container.habitRepository.getAllHabits();
    expect(stored.where((habit) => !habit.isActive), hasLength(1));
    expect(stored, hasLength(defaultHabits.length));
  });

  testWidgets('app shell navigates between non-camera destinations', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(home: AppShell(container: container, initialIndex: 3)),
    );
    await tester.pumpAndSettle();
    expect(find.text('Manage habits'), findsOneWidget);

    await tester.tap(find.text('Timeline'));
    await tester.pumpAndSettle();
    expect(find.text('Progress timeline'), findsOneWidget);

    await tester.tap(find.text('Insights'));
    await tester.pumpAndSettle();
    expect(find.text('Routine insights'), findsOneWidget);

    await tester.tap(find.text('Data'));
    await tester.pump();
    expect(find.text('Data & about'), findsOneWidget);
  });
}
