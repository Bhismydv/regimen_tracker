import 'package:flutter/material.dart';
import 'package:regimen_tracker/app/di/app_container.dart';
import 'package:regimen_tracker/domain/entities/habit.dart';
import 'package:regimen_tracker/domain/enums/measurement_type.dart';
import 'package:regimen_tracker/domain/services/default_habits.dart';
import 'package:regimen_tracker/features/daily_log/presentation/widgets/add_habit_dialog.dart';

class HabitsPage extends StatefulWidget {
  final AppContainer container;

  const HabitsPage({super.key, required this.container});

  @override
  State<HabitsPage> createState() => _HabitsPageState();
}

class _HabitsPageState extends State<HabitsPage> {
  List<Habit> habits = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadHabits();
  }

  Future<void> loadHabits() async {
    if (mounted) {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });
    }
    try {
      final loaded = await ensureDefaultHabits(widget.container.habitRepository)
        ..sort((a, b) {
          if (a.isActive != b.isActive) return a.isActive ? -1 : 1;
          return a.name.compareTo(b.name);
        });
      if (!mounted) return;
      setState(() {
        habits = loaded;
        isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
        errorMessage = 'Could not load habits: $error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage habits'),
        actions: [
          IconButton(
            key: const Key('add-habit-button'),
            tooltip: 'Add habit',
            onPressed: addHabit,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) return const Center(child: CircularProgressIndicator());
    if (errorMessage case final message?) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: loadHabits,
              icon: const Icon(Icons.refresh),
              label: const Text('Try again'),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Archived habits keep their historical timeline data but no longer appear in new daily logs.',
        ),
        const SizedBox(height: 12),
        ...habits.map(
          (habit) => Card(
            child: ListTile(
              leading: CircleAvatar(backgroundColor: Color(habit.colorValue)),
              title: Text(habit.name),
              subtitle: Text(
                '${_title(habit.category.name)} · ${_measurementLabel(habit.measurementType)}',
              ),
              onTap: () => renameHabit(habit),
              trailing: Switch(
                value: habit.isActive,
                onChanged: (active) => setHabitActive(habit, active),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> addHabit() async {
    final habit = await showDialog<Habit>(
      context: context,
      builder: (_) => const AddHabitDialog(),
    );
    if (habit == null) return;
    try {
      await widget.container.habitRepository.addHabit(habit);
      await loadHabits();
    } catch (error) {
      showError('Could not add habit: $error');
    }
  }

  Future<void> renameHabit(Habit habit) async {
    final controller = TextEditingController(text: habit.name);
    final name = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Rename habit'),
        content: TextField(
          key: const Key('rename-habit-field'),
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.sentences,
          decoration: const InputDecoration(labelText: 'Habit name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () =>
                Navigator.pop(dialogContext, controller.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (name == null || name.isEmpty || name == habit.name) return;

    try {
      await widget.container.habitRepository.updateHabit(
        habit.copyWith(name: name),
      );
      await loadHabits();
    } catch (error) {
      showError('Could not rename habit: $error');
    }
  }

  Future<void> setHabitActive(Habit habit, bool active) async {
    final index = habits.indexWhere((item) => item.id == habit.id);
    if (index < 0) return;
    final updated = habit.copyWith(isActive: active);
    setState(() => habits[index] = updated);
    try {
      await widget.container.habitRepository.updateHabit(updated);
    } catch (error) {
      if (mounted) setState(() => habits[index] = habit);
      showError('Could not update habit: $error');
    }
  }

  void showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  String _measurementLabel(MeasurementType type) => switch (type) {
    MeasurementType.binary => 'Yes / no',
    MeasurementType.scale => 'Intensity',
    MeasurementType.duration => 'Minutes',
  };

  String _title(String value) =>
      '${value[0].toUpperCase()}${value.substring(1)}';
}
