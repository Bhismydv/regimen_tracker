import 'package:flutter/material.dart';
import 'dart:io';

import 'package:regimen_tracker/features/timeline/presentation/cubit/timeline_cubit.dart';
import 'package:regimen_tracker/features/timeline/presentation/widgets/timeline_item.dart';

class TimelinePage extends StatelessWidget {
  final TimelineCubit cubit;

  const TimelinePage({super.key, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Timeline")),
      body: FutureBuilder(
        future: cubit.loadTimeline(),
        builder: (context, snapshot) {
          return StreamBuilder<List<TimelineItem>>(
            stream: cubit.stream,
            builder: (context, snapshot) {
              final items = snapshot.data ?? [];

              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];

                  return Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        // 📸 Thumbnail
                        Image.file(
                          File(item.thumbnailPath ?? item.imagePath),
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),

                        const SizedBox(height: 6),

                        // 📅 Date
                        Text(
                          "${item.date.day}/${item.date.month}", style: TextStyle(color: Colors.black),
                        ),

                        const SizedBox(height: 6),

                        // 🧴 Habit Indicators
                        Row(
                          children: item.habits.map((h) {
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 2),
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}