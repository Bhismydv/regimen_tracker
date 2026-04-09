import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as p;

import 'image_service.dart';

ProcessedImageResult processImageInIsolate(String path) {
  final originalFile = File(path);
  final bytes = originalFile.readAsBytesSync();

  final image = img.decodeImage(bytes)!;

  // Resize main image
  final resized = img.copyResize(image, width: 1080);

  // Compress main image
  final compressedBytes = img.encodeJpg(resized, quality: 70);

  final dir = originalFile.parent;

  final compressedPath =
  p.join(dir.path, "img_${DateTime.now().millisecondsSinceEpoch}.jpg");

  File(compressedPath).writeAsBytesSync(compressedBytes);

  // Create thumbnail
  final thumb = img.copyResize(image, width: 200);
  final thumbBytes = img.encodeJpg(thumb, quality: 60);

  final thumbPath =
  p.join(dir.path, "thumb_${DateTime.now().millisecondsSinceEpoch}.jpg");

  File(thumbPath).writeAsBytesSync(thumbBytes);

  // Optional: delete original to save space
  originalFile.deleteSync();

  return ProcessedImageResult(
    compressedPath: compressedPath,
    thumbnailPath: thumbPath,
  );
}