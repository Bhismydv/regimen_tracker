import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

/// Crops a portrait camera stream to the same square geometry used by the
/// image-processing pipeline.
class CameraPreviewWidget extends StatelessWidget {
  final CameraController controller;

  const CameraPreviewWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final portraitAspectRatio = 1 / controller.value.aspectRatio;

    return ClipRect(
      child: FittedBox(
        fit: BoxFit.cover,
        clipBehavior: Clip.hardEdge,
        child: SizedBox(
          width: 1000 * portraitAspectRatio,
          height: 1000,
          child: CameraPreview(controller),
        ),
      ),
    );
  }
}
