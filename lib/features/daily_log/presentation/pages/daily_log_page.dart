import 'dart:io';

import 'package:flutter/material.dart';
import 'package:regimen_tracker/app/di/app_container.dart';
import 'package:regimen_tracker/core/database/database_provider.dart';
import 'package:regimen_tracker/data/database/app_database.dart' as db;
import 'package:regimen_tracker/data/repositories/habit_repository_impl.dart';
import 'package:regimen_tracker/data/repositories/log_repository_impl.dart';
import 'package:regimen_tracker/domain/enums/habit_category.dart';
import 'package:regimen_tracker/domain/enums/measurement_type.dart';
import 'package:regimen_tracker/features/timeline/presentation/cubit/timeline_cubit.dart';
import 'package:regimen_tracker/features/timeline/presentation/pages/timeline_page.dart';
import '../../../../domain/entities/daily_log.dart';
import '../../../../domain/entities/habit.dart' as domain;
import '../../../../domain/entities/habit_log_entry.dart';

class DailyLogPage extends StatefulWidget {
  final String imagePath;
  final AppContainer container;

  const DailyLogPage({
    super.key,
    required this.imagePath,
    required this.container,
  });

  @override
  State<DailyLogPage> createState() => _DailyLogPageState();
}

class _DailyLogPageState extends State<DailyLogPage> {
  final Map<String, double> selectedHabits = {};
  late HabitRepositoryImpl habitRepository;
  List<domain.Habit> habits = [];
  late LogRepositoryImpl logRepository;

  @override
  void initState() {
    super.initState();

    habitRepository = widget.container.habitRepository;
    logRepository = widget.container.logRepository;

    loadHabits();

  }

  Future<void> loadHabits() async {
    final existing = await habitRepository.getAllHabits();

    if (existing.isEmpty) {
      final defaultHabits = [
        domain.Habit(
          id: "1",
          name: "Exfoliation",
          category: HabitCategory.exfoliation,
          measurementType: MeasurementType.scale,
          intensityScaleMax: 10,
          isActive: true,
          colorValue: 0xFFE57373, // red
        ),
        domain.Habit(
          id: "2",
          name: "Hydration",
          category: HabitCategory.hydration,
          measurementType: MeasurementType.scale,
          intensityScaleMax: 10,
          isActive: true,
          colorValue: 0xFF64B5F6, // blue
        ),
        domain.Habit(
          id: "3",
          name: "Retinol",
          category: HabitCategory.treatment,
          measurementType: MeasurementType.scale,
          intensityScaleMax: 10,
          isActive: true,
          colorValue: 0xFFBA68C8, // purple
        ),
        domain.Habit(
          id: "4",
          name: "Sunscreen",
          category: HabitCategory.treatment,
          measurementType: MeasurementType.scale,
          intensityScaleMax: 10,
          isActive: true,
          colorValue: 0xFFFFD54F, // yellow
        ),
      ];

      for (final habit in defaultHabits) {
        await habitRepository.addHabit(habit);
      }
    }

    final updated = await habitRepository.getAllHabits();

    setState(() {
      habits = updated;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Log Your Routine")),
        body: Column(
          children: [
            SizedBox(
              height: 200,
              child: Image.file(
                File(widget.imagePath),
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 10),


              Expanded(
                child: ListView(
                  children: habits.map((habit) {
                    return buildHabitTile(habit);
                  }).toList(),
                ),
              ),

            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: ElevatedButton(
                  onPressed: () async {
                    final now = DateTime.now();
                    final logDate = DateTime(now.year, now.month, now.day);

                    // ✅ 1. SAVE DAILY LOG (CRITICAL FIX)
                    await logRepository.addDailyLog(
                      DailyLog(
                        date: logDate,
                        imagePath: widget.imagePath,
                        thumbnailPath: null, // keep null for now
                      ),
                    );

                    // ✅ 2. SAVE HABIT ENTRIES
                    final entries = selectedHabits.entries.map((e) {
                      return HabitLogEntry(
                        id: "${DateTime.now().millisecondsSinceEpoch}_${e.key}",
                        habitId: e.key,
                        logDate: logDate,
                        value: e.value,
                      );
                    }).toList();

                    await logRepository.addHabitEntries(entries);

                    if (!mounted) return;

                    // ✅ 3. FEEDBACK
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Log saved")),
                    );

                    // ✅ 4. NAVIGATE TO TIMELINE
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TimelinePage(
                          cubit: TimelineCubit(widget.container.logRepository, widget.container.habitRepository),
                        ),
                      ),
                    );
                  },
                  child: const Text("Save Log"),
                ),
              ),
            )
          ],
        )
    );
  }

  Widget buildHabitTile(domain.Habit habit) {
    return ListTile(
      title: Text(habit.name),
      subtitle: Text("${habit.category.name} • ${selectedHabits[habit.id]?.toInt() ?? 0}"),
        trailing: SizedBox(
          width: 150,
          child: Slider(
            value: selectedHabits[habit.id] ?? 0,
            min: 0,
            max: habit.intensityScaleMax.toDouble(),
            onChanged: (value) {
              setState(() {
                selectedHabits[habit.id] = value;
              });
            },
          ),
        ),
    );
  }
}