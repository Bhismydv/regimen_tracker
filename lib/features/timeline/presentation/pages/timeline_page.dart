import 'package:flutter/material.dart';
import 'dart:io';

import 'package:regimen_tracker/features/timeline/presentation/cubit/timeline_cubit.dart';
import 'package:regimen_tracker/features/timeline/presentation/widgets/timeline_item.dart';

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
    widget.cubit.loadTimeline(); // ✅ load once
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Timeline")),
      body: StreamBuilder<List<TimelineItem>>(
        stream: widget.cubit.stream,
        builder: (context, snapshot) {
          final items = snapshot.data ?? [];

          if (items.isEmpty) {
            return const Center(child: Text("No logs yet"));
          }

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];

              return Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    Image.file(
                      File(item.thumbnailPath ?? item.imagePath),
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),

                    const SizedBox(height: 6),

                    Text(
                      "${item.date.day}/${item.date.month}",
                      style: const TextStyle(color: Colors.black),
                    ),

                    const SizedBox(height: 6),

                    Row(
                      children: item.habits.map((h) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: Color(
                              item.habitMap[h.habitId]?.colorValue ??
                                  0xFFCCCCCC,
                            ),
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
      ),
    );
  }
}