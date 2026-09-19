import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as p;

import 'image_service.dart';

const _storedImageSize = 1080;
const _thumbnailSize = 240;

ProcessedImageResult processImageInIsolate({
  required String sourcePath,
  required String destinationDirectoryPath,
}) {
  final originalFile = File(sourcePath);
  final bytes = originalFile.readAsBytesSync();
  final decodedImage = img.decodeImage(bytes);

  if (decodedImage == null) {
    throw const FormatException('The captured image could not be decoded.');
  }

  final orientedImage = img.bakeOrientation(decodedImage);
  final cropSize = orientedImage.width < orientedImage.height
      ? orientedImage.width
      : orientedImage.height;
  final squareImage = img.copyCrop(
    orientedImage,
    x: (orientedImage.width - cropSize) ~/ 2,
    y: (orientedImage.height - cropSize) ~/ 2,
    width: cropSize,
    height: cropSize,
  );
  final storedImage = img.copyResize(
    squareImage,
    width: _storedImageSize,
    height: _storedImageSize,
    interpolation: img.Interpolation.average,
  );
  final thumbnail = img.copyResize(
    squareImage,
    width: _thumbnailSize,
    height: _thumbnailSize,
    interpolation: img.Interpolation.average,
  );

  final destinationDirectory = Directory(destinationDirectoryPath)
    ..createSync(recursive: true);
  final fileId = DateTime.now().microsecondsSinceEpoch;
  final compressedPath = p.join(destinationDirectory.path, 'image_$fileId.jpg');
  final thumbnailPath = p.join(
    destinationDirectory.path,
    'thumbnail_$fileId.jpg',
  );
  final compressedTempPath = '$compressedPath.tmp';
  final thumbnailTempPath = '$thumbnailPath.tmp';

  try {
    File(
      compressedTempPath,
    ).writeAsBytesSync(img.encodeJpg(storedImage, quality: 78), flush: true);
    File(
      thumbnailTempPath,
    ).writeAsBytesSync(img.encodeJpg(thumbnail, quality: 68), flush: true);
    File(compressedTempPath).renameSync(compressedPath);
    File(thumbnailTempPath).renameSync(thumbnailPath);
  } catch (_) {
    _deleteIfPresent(compressedTempPath);
    _deleteIfPresent(thumbnailTempPath);
    _deleteIfPresent(compressedPath);
    _deleteIfPresent(thumbnailPath);
    rethrow;
  }

  // Camera captures are temporary. Only remove the source after both durable
  // files have been written successfully.
  _deleteIfPresent(sourcePath);

  return ProcessedImageResult(
    compressedPath: compressedPath,
    thumbnailPath: thumbnailPath,
  );
}

void _deleteIfPresent(String path) {
  final file = File(path);
  if (file.existsSync()) {
    try {
      file.deleteSync();
    } on FileSystemException {
      // A cleanup failure must not discard an otherwise valid processed image.
    }
  }
}
