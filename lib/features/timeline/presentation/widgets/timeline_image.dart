import 'dart:io';

import 'package:flutter/material.dart';
import 'package:regimen_tracker/domain/entities/habit.dart';
import 'package:regimen_tracker/features/timeline/presentation/widgets/timeline_item.dart';

const _columnWidth = 104.0;
const _imageSize = 76.0;
const _leftInset = 16.0;

class TimelineChart extends StatelessWidget {
  final List<TimelineItem> items;
  final List<Habit> visibleHabits;
  final List<DateTime> selectedDates;
  final ValueChanged<DateTime> onDateSelected;

  const TimelineChart({
    super.key,
    required this.items,
    required this.visibleHabits,
    required this.selectedDates,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    final chartWidth = _leftInset * 2 + items.length * _columnWidth;
    final chartHeight = 250.0 + visibleHabits.length * 26;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.only(bottom: 8),
      child: SizedBox(
        width: chartWidth,
        height: chartHeight,
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: _TimelinePainter(
                  items: items,
                  visibleHabits: visibleHabits,
                ),
              ),
            ),
            for (var index = 0; index < items.length; index++)
              _TimelineThumbnail(
                item: items[index],
                index: index,
                selectionIndex: selectedDates.indexOf(items[index].date),
                onTap: () => onDateSelected(items[index].date),
              ),
          ],
        ),
      ),
    );
  }
}

class _TimelineThumbnail extends StatelessWidget {
  final TimelineItem item;
  final int index;
  final int selectionIndex;
  final VoidCallback onTap;

  const _TimelineThumbnail({
    required this.item,
    required this.index,
    required this.selectionIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final selected = selectionIndex >= 0;
    final left =
        _leftInset + index * _columnWidth + (_columnWidth - _imageSize) / 2;

    return Positioned(
      top: 10,
      left: left,
      width: _imageSize,
      child: Column(
        children: [
          GestureDetector(
            key: ValueKey('timeline-date-${item.date.toIso8601String()}'),
            onTap: onTap,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  width: _imageSize,
                  height: _imageSize,
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: selected
                        ? Theme.of(context).colorScheme.primary
                        : Colors.transparent,
                  ),
                  child: ClipOval(
                    child: Image.file(
                      File(item.thumbnailPath ?? item.imagePath),
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => const ColoredBox(
                        color: Colors.black12,
                        child: Icon(Icons.broken_image_outlined),
                      ),
                    ),
                  ),
                ),
                if (selected)
                  Positioned(
                    right: -4,
                    top: -4,
                    child: CircleAvatar(
                      radius: 11,
                      child: Text(
                        selectionIndex == 0 ? '1' : '2',
                        style: const TextStyle(fontSize: 11),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          Text(
            '${item.date.day}/${item.date.month}',
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ],
      ),
    );
  }
}

class _TimelinePainter extends CustomPainter {
  final List<TimelineItem> items;
  final List<Habit> visibleHabits;

  _TimelinePainter({required this.items, required this.visibleHabits});

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.08)
      ..strokeWidth = 1;
    final firstTrackY = 132.0;

    for (var index = 0; index < items.length; index++) {
      final x = _centerX(index);
      canvas.drawLine(Offset(x, 112), Offset(x, size.height - 12), gridPaint);
    }

    for (var habitIndex = 0; habitIndex < visibleHabits.length; habitIndex++) {
      final habit = visibleHabits[habitIndex];
      final y = firstTrackY + habitIndex * 26;
      final color = Color(habit.colorValue);
      final trackPaint = Paint()
        ..color = color.withValues(alpha: 0.16)
        ..strokeWidth = 2;
      canvas.drawLine(
        Offset(_centerX(0), y),
        Offset(_centerX(items.length - 1), y),
        trackPaint,
      );

      for (var itemIndex = 0; itemIndex < items.length; itemIndex++) {
        final value = items[itemIndex].valueForHabit(habit.id);
        if (value == null) continue;
        final maximum = habit.intensityScaleMax <= 0
            ? 1
            : habit.intensityScaleMax;
        final ratio = (value / maximum).clamp(0.0, 1.0);
        canvas.drawCircle(
          Offset(_centerX(itemIndex), y),
          4 + ratio * 5,
          Paint()..color = color,
        );
      }
    }

    final graphTop = firstTrackY + visibleHabits.length * 26 + 26;
    _drawOutcomeLine(
      canvas,
      graphTop,
      items.map((item) => item.irritationScore).toList(),
      const Color(0xFFE53935),
    );
    _drawOutcomeLine(
      canvas,
      graphTop,
      items.map((item) => item.oilinessScore).toList(),
      const Color(0xFF1E88E5),
    );
  }

  void _drawOutcomeLine(
    Canvas canvas,
    double graphTop,
    List<double?> values,
    Color color,
  ) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    final pointPaint = Paint()..color = color;
    Offset? previousPoint;

    for (var index = 0; index < values.length; index++) {
      final value = values[index];
      if (value == null) {
        previousPoint = null;
        continue;
      }
      final normalized = (value / 10).clamp(0.0, 1.0);
      final point = Offset(_centerX(index), graphTop + 70 - normalized * 70);
      if (previousPoint != null) canvas.drawLine(previousPoint, point, paint);
      canvas.drawCircle(point, 4, pointPaint);
      previousPoint = point;
    }
  }

  double _centerX(int index) =>
      _leftInset + index * _columnWidth + _columnWidth / 2;

  @override
  bool shouldRepaint(covariant _TimelinePainter oldDelegate) => true;
}
