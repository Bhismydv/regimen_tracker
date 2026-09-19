import 'package:flutter/material.dart';
import 'package:regimen_tracker/features/comparison/presentation/widgets/image_comparison_slider.dart';
import 'package:regimen_tracker/features/timeline/presentation/widgets/timeline_item.dart';

class ComparisonPage extends StatelessWidget {
  final TimelineItem before;
  final TimelineItem after;

  const ComparisonPage({super.key, required this.before, required this.after});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Visual comparison')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ImageComparisonSlider(
            beforeImagePath: before.imagePath,
            afterImagePath: after.imagePath,
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _DateSummary(label: 'Before', item: before),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Icon(Icons.arrow_forward),
              ),
              Expanded(
                child: _DateSummary(label: 'After', item: after),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Drag the white divider to reveal either aligned image.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _DateSummary extends StatelessWidget {
  final String label;
  final TimelineItem item;

  const _DateSummary({required this.label, required this.item});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: Theme.of(context).textTheme.labelLarge),
        Text('${item.date.day}/${item.date.month}/${item.date.year}'),
        if (item.irritationScore case final score?)
          Text('Irritation ${score.round()}/10'),
        if (item.oilinessScore case final score?)
          Text('Oiliness ${score.round()}/10'),
      ],
    );
  }
}
