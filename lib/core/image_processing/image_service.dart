import 'dart:isolate';
import 'dart:io';

import 'image_isolate.dart';

class ImageService {
  static Future<ProcessedImageResult> processImage(String path) async {
    return await Isolate.run(() {
      return processImageInIsolate(path);
    });
  }
}

class ProcessedImageResult {
  final String compressedPath;
  final String thumbnailPath;

  ProcessedImageResult({
    required this.compressedPath,
    required this.thumbnailPath,
  });
}