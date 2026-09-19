import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:regimen_tracker/features/comparison/presentation/pages/comparison_page.dart';
import 'package:regimen_tracker/features/insights/presentation/cubit/insights_cubit.dart';
import 'package:regimen_tracker/features/insights/presentation/pages/insights_page.dart';
import 'package:regimen_tracker/features/timeline/presentation/cubit/timeline_cubit.dart';
import 'package:regimen_tracker/features/timeline/presentation/cubit/timeline_state.dart';
import 'package:regimen_tracker/features/timeline/presentation/widgets/habit_indicator.dart';
import 'package:regimen_tracker/features/timeline/presentation/widgets/timeline_image.dart';

class TimelinePage extends StatefulWidget {
  final TimelineCubit cubit;

  const TimelinePage({super.key, required this.cubit});

  @override
  State<TimelinePage> createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> {
  @override
  void initState() {
    super.initState();
    widget.cubit.loadTimeline();
  }

  @override
  void dispose() {
    widget.cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.cubit,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Progress timeline'),
          actions: [
            IconButton(
              key: const Key('open-insights-button'),
              tooltip: 'Routine insights',
              onPressed: openInsights,
              icon: const Icon(Icons.insights),
            ),
            IconButton(
              tooltip: 'Refresh timeline',
              onPressed: widget.cubit.loadTimeline,
              icon: const Icon(Icons.refresh),
            ),
          ],
        ),
        body: BlocBuilder<TimelineCubit, TimelineState>(
          builder: (context, state) {
            return switch (state) {
              TimelineInitial() || TimelineLoading() => const Center(
                child: CircularProgressIndicator(),
              ),
              TimelineEmpty() => const _EmptyTimeline(),
              TimelineFailure(:final message) => _TimelineError(
                message: message,
                onRetry: widget.cubit.loadTimeline,
              ),
              TimelineLoaded() => _buildLoadedTimeline(context, state),
            };
          },
        ),
      ),
    );
  }

  void openInsights() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => InsightsPage(
          cubit: InsightsCubit(
            widget.cubit.logRepository,
            widget.cubit.habitRepository,
          ),
        ),
      ),
    );
  }

  Widget _buildLoadedTimeline(BuildContext context, TimelineLoaded state) {
    final visibleHabits = state.habits
        .where((habit) => state.visibleHabitIds.contains(habit.id))
        .toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Tap two photos to compare',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Text('${state.items.length} days'),
            ],
          ),
        ),
        if (state.habits.isNotEmpty)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: state.habits.map((habit) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: HabitIndicator(
                    habit: habit,
                    selected: state.visibleHabitIds.contains(habit.id),
                    onSelected: () => widget.cubit.toggleHabit(habit.id),
                  ),
                );
              }).toList(),
            ),
          ),
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 10, 16, 2),
          child: Row(
            children: [
              _LegendDot(color: Color(0xFFE53935), label: 'Irritation'),
              SizedBox(width: 16),
              _LegendDot(color: Color(0xFF1E88E5), label: 'Oiliness'),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: TimelineChart(
              items: state.items,
              visibleHabits: visibleHabits,
              selectedDates: state.selectedDates,
              onDateSelected: widget.cubit.toggleDate,
            ),
          ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                key: const Key('compare-selected-dates-button'),
                onPressed: state.selectedDates.length == 2
                    ? () => openComparison(context, state)
                    : null,
                icon: const Icon(Icons.compare),
                label: Text(
                  state.selectedDates.length == 2
                      ? 'Compare selected dates'
                      : 'Select ${2 - state.selectedDates.length} more date${state.selectedDates.length == 1 ? '' : 's'}',
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void openComparison(BuildContext context, TimelineLoaded state) {
    final selectedItems = state.selectedDates.map((date) {
      return state.items.firstWhere((item) => item.date == date);
    }).toList()..sort((a, b) => a.date.compareTo(b.date));

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ComparisonPage(
          before: selectedItems.first,
          after: selectedItems.last,
        ),
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(radius: 5, backgroundColor: color),
        const SizedBox(width: 5),
        Text(label),
      ],
    );
  }
}

class _EmptyTimeline extends StatelessWidget {
  const _EmptyTimeline();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.timeline, size: 56),
            SizedBox(height: 16),
            Text('No daily logs yet', style: TextStyle(fontSize: 20)),
            SizedBox(height: 8),
            Text(
              'Capture your first aligned photo to begin the timeline.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _TimelineError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _TimelineError({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }
}
