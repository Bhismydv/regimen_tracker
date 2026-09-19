import 'dart:isolate';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'image_isolate.dart';

class ImageService {
  static Future<ProcessedImageResult> processImage(String path) async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final imageDirectoryPath = p.join(
      documentsDirectory.path,
      'regimen_images',
    );

    return Isolate.run(
      () => processImageInIsolate(
        sourcePath: path,
        destinationDirectoryPath: imageDirectoryPath,
      ),
    );
  }

  static Future<void> deleteProcessedImages({
    required String imagePath,
    String? thumbnailPath,
  }) async {
    final paths = {imagePath, ?thumbnailPath};

    for (final path in paths) {
      final file = File(path);
      try {
        if (await file.exists()) {
          await file.delete();
        }
      } on FileSystemException {
        // Stale files can be cleaned during a later maintenance pass.
      }
    }
  }
}

class ProcessedImageResult {
  final String compressedPath;
  final String thumbnailPath;

  const ProcessedImageResult({
    required this.compressedPath,
    required this.thumbnailPath,
  });
}
