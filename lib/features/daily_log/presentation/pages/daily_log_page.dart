import 'dart:io';

import 'package:flutter/material.dart';
import 'package:regimen_tracker/app/di/app_container.dart';
import 'package:regimen_tracker/core/image_processing/image_service.dart';
import 'package:regimen_tracker/data/repositories/habit_repository_impl.dart';
import 'package:regimen_tracker/data/repositories/log_repository_impl.dart';
import 'package:regimen_tracker/domain/entities/daily_log.dart';
import 'package:regimen_tracker/domain/entities/habit.dart' as domain;
import 'package:regimen_tracker/domain/entities/habit_log_entry.dart';
import 'package:regimen_tracker/domain/enums/skin_condition_tag.dart';
import 'package:regimen_tracker/domain/services/default_habits.dart';
import 'package:regimen_tracker/features/daily_log/presentation/widgets/add_habit_dialog.dart';
import 'package:regimen_tracker/features/daily_log/presentation/widgets/habit_tile.dart';
import 'package:regimen_tracker/features/daily_log/presentation/widgets/intensity_slider.dart';
import 'package:regimen_tracker/features/daily_log/presentation/widgets/save_button.dart';

class DailyLogPage extends StatefulWidget {
  final String imagePath;
  final String thumbnailPath;
  final AppContainer container;
  final DateTime? date;

  const DailyLogPage({
    super.key,
    required this.imagePath,
    required this.thumbnailPath,
    required this.container,
    this.date,
  });

  @override
  State<DailyLogPage> createState() => _DailyLogPageState();
}

class _DailyLogPageState extends State<DailyLogPage> {
  final selectedHabits = <String, double>{};
  final notesController = TextEditingController();
  late final HabitRepositoryImpl habitRepository;
  late final LogRepositoryImpl logRepository;
  late final DateTime logDate;

  List<domain.Habit> habits = [];
  DailyLog? previousLog;
  SkinConditionTag? conditionTag;
  double? irritationScore;
  double? oilinessScore;
  bool isLoading = true;
  bool isSaving = false;
  String? loadError;

  @override
  void initState() {
    super.initState();
    habitRepository = widget.container.habitRepository;
    logRepository = widget.container.logRepository;
    final requestedDate = widget.date ?? DateTime.now();
    logDate = DateTime(
      requestedDate.year,
      requestedDate.month,
      requestedDate.day,
    );
    loadForm();
  }

  @override
  void dispose() {
    notesController.dispose();
    super.dispose();
  }

  Future<void> loadForm() async {
    if (mounted) {
      setState(() {
        isLoading = true;
        loadError = null;
      });
    }

    try {
      final storedHabits = await ensureDefaultHabits(habitRepository);

      final savedLog = await logRepository.getLogByDate(logDate);
      final savedEntries = await logRepository.getEntriesByDate(logDate);

      if (!mounted) return;
      setState(() {
        habits = storedHabits.where((habit) => habit.isActive).toList();
        previousLog = savedLog;
        conditionTag = savedLog?.conditionTag;
        irritationScore = savedLog?.irritationScore;
        oilinessScore = savedLog?.oilinessScore;
        notesController.text = savedLog?.notes ?? '';
        selectedHabits
          ..clear()
          ..addEntries(
            savedEntries.map((entry) => MapEntry(entry.habitId, entry.value)),
          );
        isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
        loadError = 'Could not load this daily log: $error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          previousLog == null ? 'Log your routine' : 'Edit daily log',
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (loadError case final error?) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(error, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: loadForm,
                icon: const Icon(Icons.refresh),
                label: const Text('Try again'),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            children: [
              _buildPhoto(),
              const SizedBox(height: 24),
              _sectionTitle('Routine variables'),
              const SizedBox(height: 8),
              ...habits.map(
                (habit) => HabitTile(
                  key: ValueKey(habit.id),
                  habit: habit,
                  value: selectedHabits[habit.id],
                  onChanged: (value) {
                    setState(() {
                      if (value == null) {
                        selectedHabits.remove(habit.id);
                      } else {
                        selectedHabits[habit.id] = value;
                      }
                    });
                  },
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  key: const Key('add-custom-habit-button'),
                  onPressed: addCustomHabit,
                  icon: const Icon(Icons.add),
                  label: const Text('Add custom habit'),
                ),
              ),
              const SizedBox(height: 16),
              _sectionTitle('Visual outcomes'),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      DropdownButtonFormField<SkinConditionTag?>(
                        initialValue: conditionTag,
                        decoration: const InputDecoration(
                          labelText: 'Overall condition',
                          prefixIcon: Icon(Icons.face_retouching_natural),
                        ),
                        items: [
                          const DropdownMenuItem<SkinConditionTag?>(
                            value: null,
                            child: Text('Not recorded'),
                          ),
                          ...SkinConditionTag.values.map(
                            (tag) => DropdownMenuItem<SkinConditionTag?>(
                              value: tag,
                              child: Text(_title(tag.name)),
                            ),
                          ),
                        ],
                        onChanged: (value) =>
                            setState(() => conditionTag = value),
                      ),
                      const SizedBox(height: 12),
                      OutcomeScoreSlider(
                        label: 'Irritation',
                        icon: Icons.local_fire_department_outlined,
                        value: irritationScore,
                        onChanged: (value) =>
                            setState(() => irritationScore = value),
                      ),
                      OutcomeScoreSlider(
                        label: 'Oiliness',
                        icon: Icons.water_drop_outlined,
                        value: oilinessScore,
                        onChanged: (value) =>
                            setState(() => oilinessScore = value),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                key: const Key('daily-notes-field'),
                controller: notesController,
                minLines: 3,
                maxLines: 6,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Notes',
                  hintText:
                      'Products, weather, reactions, or anything unusual…',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
              ),
            ],
          ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: SaveButton(isSaving: isSaving, onPressed: saveLog),
          ),
        ),
      ],
    );
  }

  Widget _buildPhoto() {
    return AspectRatio(
      aspectRatio: 1,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.file(
          File(widget.imagePath),
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => const ColoredBox(
            color: Colors.black12,
            child: Center(child: Icon(Icons.broken_image_outlined, size: 48)),
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(title, style: Theme.of(context).textTheme.titleMedium);
  }

  Future<void> addCustomHabit() async {
    final habit = await showDialog<domain.Habit>(
      context: context,
      builder: (_) => const AddHabitDialog(),
    );
    if (habit == null) return;

    try {
      await habitRepository.addHabit(habit);
      if (!mounted) return;
      setState(() => habits = [...habits, habit]);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not add habit: $error')));
    }
  }

  Future<void> saveLog() async {
    if (isSaving) return;
    setState(() => isSaving = true);

    try {
      final pendingEntries = selectedHabits.entries.map((entry) {
        return HabitLogEntry(
          id: '${logDate.toIso8601String()}_${entry.key}',
          habitId: entry.key,
          logDate: logDate,
          value: entry.value,
        );
      }).toList();
      final notes = notesController.text.trim();

      await logRepository.saveDailyLogWithEntries(
        DailyLog(
          date: logDate,
          imagePath: widget.imagePath,
          thumbnailPath: widget.thumbnailPath,
          notes: notes.isEmpty ? null : notes,
          conditionTag: conditionTag,
          irritationScore: irritationScore,
          oilinessScore: oilinessScore,
        ),
        pendingEntries,
      );

      final oldLog = previousLog;
      if (oldLog != null && oldLog.imagePath != widget.imagePath) {
        await ImageService.deleteProcessedImages(
          imagePath: oldLog.imagePath,
          thumbnailPath: oldLog.thumbnailPath,
        );
      }

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Daily log saved')));
      Navigator.pop(context, true);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not save the daily log: $error')),
      );
    } finally {
      if (mounted) setState(() => isSaving = false);
    }
  }

  String _title(String value) =>
      '${value[0].toUpperCase()}${value.substring(1)}';
}
