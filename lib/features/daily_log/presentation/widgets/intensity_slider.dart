import 'package:flutter/material.dart';

class OutcomeScoreSlider extends StatelessWidget {
  final String label;
  final IconData icon;
  final double? value;
  final ValueChanged<double?> onChanged;

  const OutcomeScoreSlider({
    super.key,
    required this.label,
    required this.icon,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final score = value;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text(label)),
            if (score == null)
              TextButton(
                onPressed: () => onChanged(0),
                child: const Text('Add score'),
              )
            else ...[
              Text('${score.round()}/10'),
              IconButton(
                tooltip: 'Clear $label',
                onPressed: () => onChanged(null),
                icon: const Icon(Icons.close, size: 18),
              ),
            ],
          ],
        ),
        if (score != null)
          Slider(
            value: score,
            min: 0,
            max: 10,
            divisions: 10,
            label: score.round().toString(),
            onChanged: (nextValue) => onChanged(nextValue),
          ),
      ],
    );
  }
}
