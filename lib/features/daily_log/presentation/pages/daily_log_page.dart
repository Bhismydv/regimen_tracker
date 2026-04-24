import 'dart:io';

import 'package:flutter/material.dart';
import '../../../camera_capture/presentation/pages/camera_page.dart';
import '../../../../domain/entities/habit.dart';

class DailyLogPage extends StatefulWidget {
  final String imagePath;

  const DailyLogPage({super.key, required this.imagePath});

  @override
  State<DailyLogPage> createState() => _DailyLogPageState();
}

class _DailyLogPageState extends State<DailyLogPage> {
  final Map<String, double> selectedHabits = {};

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
                children: [
                  buildHabitTile("Exfoliation"),
                  buildHabitTile("Hydration"),
                  buildHabitTile("Retinol"),
                ],
              ),
            ),

            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, selectedHabits);
                  },
                  child: const Text("Save Log"),
                ),
              ),
            )
          ],
        )
    );
  }

  Widget buildHabitTile(String habitName) {
    return ListTile(
      title: Text(habitName),
      trailing: SizedBox(
        width: 160,
        child: Row(
          children: [
            Expanded(
              child: Slider(
                value: selectedHabits[habitName] ?? 0,
                min: 0,
                max: 10,
                divisions: 10,
                label: (selectedHabits[habitName] ?? 0).toStringAsFixed(0),
                onChanged: (value) {
                  setState(() {
                    selectedHabits[habitName] = value;
                  });
                },
              ),
            ),
            Text((selectedHabits[habitName] ?? 0).toStringAsFixed(0)),
          ],
        ),
      ),
    );
  }
}