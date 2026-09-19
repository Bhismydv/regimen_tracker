import 'package:flutter/material.dart';
import 'package:regimen_tracker/app/di/app_container.dart';
import 'package:regimen_tracker/features/camera_capture/presentation/pages/camera_page.dart';
import 'package:regimen_tracker/features/habits/presentation/pages/habits_page.dart';
import 'package:regimen_tracker/features/insights/presentation/cubit/insights_cubit.dart';
import 'package:regimen_tracker/features/insights/presentation/pages/insights_page.dart';
import 'package:regimen_tracker/features/settings/presentation/pages/data_settings_page.dart';
import 'package:regimen_tracker/features/timeline/presentation/cubit/timeline_cubit.dart';
import 'package:regimen_tracker/features/timeline/presentation/pages/timeline_page.dart';

class AppShell extends StatefulWidget {
  final AppContainer container;
  final int initialIndex;

  const AppShell({super.key, required this.container, this.initialIndex = 0})
    : assert(initialIndex >= 0 && initialIndex <= 4);

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  late int selectedIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: KeyedSubtree(key: ValueKey(selectedIndex), child: _selectedPage()),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: selectDestination,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.camera_alt_outlined),
            selectedIcon: Icon(Icons.camera_alt),
            label: 'Capture',
          ),
          NavigationDestination(
            icon: Icon(Icons.timeline_outlined),
            selectedIcon: Icon(Icons.timeline),
            label: 'Timeline',
          ),
          NavigationDestination(
            icon: Icon(Icons.insights_outlined),
            selectedIcon: Icon(Icons.insights),
            label: 'Insights',
          ),
          NavigationDestination(
            icon: Icon(Icons.tune_outlined),
            selectedIcon: Icon(Icons.tune),
            label: 'Habits',
          ),
          NavigationDestination(
            icon: Icon(Icons.storage_outlined),
            selectedIcon: Icon(Icons.storage),
            label: 'Data',
          ),
        ],
      ),
    );
  }

  Widget _selectedPage() {
    return switch (selectedIndex) {
      0 => CameraPage(
        container: widget.container,
        onLogSaved: () => selectDestination(1),
      ),
      1 => TimelinePage(
        cubit: TimelineCubit(
          widget.container.logRepository,
          widget.container.habitRepository,
        ),
      ),
      2 => InsightsPage(
        cubit: InsightsCubit(
          widget.container.logRepository,
          widget.container.habitRepository,
        ),
      ),
      3 => HabitsPage(container: widget.container),
      4 => DataSettingsPage(container: widget.container),
      _ => throw StateError('Unknown destination $selectedIndex'),
    };
  }

  void selectDestination(int index) {
    if (index == selectedIndex) return;
    setState(() => selectedIndex = index);
  }
}
