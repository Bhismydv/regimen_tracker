import 'package:flutter/material.dart';

class AlignmentGrid extends StatelessWidget {
  const AlignmentGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      key: const Key('camera-alignment-grid'),
      child: CustomPaint(painter: _AlignmentGridPainter(), size: Size.infinite),
    );
  }
}

class _AlignmentGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final guidePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.72)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final subtlePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.28)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final center = size.center(Offset.zero);
    final faceRect = Rect.fromCenter(
      center: center.translate(0, size.height * 0.015),
      width: size.width * 0.55,
      height: size.height * 0.76,
    );
    canvas.drawOval(faceRect, guidePaint);

    final eyeY = size.height * 0.42;
    canvas.drawLine(
      Offset(size.width * 0.26, eyeY),
      Offset(size.width * 0.74, eyeY),
      guidePaint,
    );
    canvas.drawLine(
      Offset(center.dx, size.height * 0.14),
      Offset(center.dx, size.height * 0.86),
      subtlePaint,
    );

    const cornerLength = 22.0;
    for (final corner in <Offset>[
      Offset.zero,
      Offset(size.width, 0),
      Offset(0, size.height),
      Offset(size.width, size.height),
    ]) {
      final horizontalDirection = corner.dx == 0 ? 1.0 : -1.0;
      final verticalDirection = corner.dy == 0 ? 1.0 : -1.0;
      canvas.drawLine(
        corner,
        corner.translate(horizontalDirection * cornerLength, 0),
        subtlePaint,
      );
      canvas.drawLine(
        corner,
        corner.translate(0, verticalDirection * cornerLength),
        subtlePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _AlignmentGridPainter oldDelegate) => false;
}
