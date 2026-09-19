import 'dart:io';

import 'package:flutter/material.dart';

class ImageComparisonSlider extends StatefulWidget {
  final String beforeImagePath;
  final String afterImagePath;

  const ImageComparisonSlider({
    super.key,
    required this.beforeImagePath,
    required this.afterImagePath,
  });

  @override
  State<ImageComparisonSlider> createState() => _ImageComparisonSliderState();
}

class _ImageComparisonSliderState extends State<ImageComparisonSlider> {
  double reveal = 0.5;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return GestureDetector(
            key: const Key('image-comparison-slider'),
            behavior: HitTestBehavior.opaque,
            onTapDown: (details) =>
                updateReveal(details.localPosition.dx, constraints.maxWidth),
            onHorizontalDragUpdate: (details) =>
                updateReveal(details.localPosition.dx, constraints.maxWidth),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  _ComparisonImage(path: widget.afterImagePath),
                  ClipRect(
                    child: Align(
                      key: const Key('before-image-reveal'),
                      alignment: Alignment.centerLeft,
                      widthFactor: reveal,
                      child: SizedBox(
                        width: constraints.maxWidth,
                        height: constraints.maxHeight,
                        child: _ComparisonImage(path: widget.beforeImagePath),
                      ),
                    ),
                  ),
                  Positioned(
                    left: constraints.maxWidth * reveal - 1.5,
                    top: 0,
                    bottom: 0,
                    width: 3,
                    child: const ColoredBox(color: Colors.white),
                  ),
                  Positioned(
                    left: constraints.maxWidth * reveal - 18,
                    top: constraints.maxHeight / 2 - 18,
                    child: const CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.drag_handle, color: Colors.black87),
                    ),
                  ),
                  const Positioned(
                    left: 12,
                    top: 12,
                    child: _ImageLabel('Before'),
                  ),
                  const Positioned(
                    right: 12,
                    top: 12,
                    child: _ImageLabel('After'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void updateReveal(double horizontalPosition, double width) {
    setState(() => reveal = (horizontalPosition / width).clamp(0.0, 1.0));
  }
}

class _ComparisonImage extends StatelessWidget {
  final String path;

  const _ComparisonImage({required this.path});

  @override
  Widget build(BuildContext context) {
    return Image.file(
      File(path),
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => const ColoredBox(
        color: Colors.black12,
        child: Center(child: Icon(Icons.broken_image_outlined, size: 48)),
      ),
    );
  }
}

class _ImageLabel extends StatelessWidget {
  final String text;

  const _ImageLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Text(text, style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}
