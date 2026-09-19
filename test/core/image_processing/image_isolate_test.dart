import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as p;
import 'package:regimen_tracker/core/image_processing/image_isolate.dart';

void main() {
  late Directory temporaryDirectory;

  setUp(() {
    temporaryDirectory = Directory.systemTemp.createTempSync(
      'regimen_image_test_',
    );
  });

  tearDown(() {
    if (temporaryDirectory.existsSync()) {
      temporaryDirectory.deleteSync(recursive: true);
    }
  });

  test('creates durable square image and thumbnail, then removes source', () {
    final sourcePath = p.join(temporaryDirectory.path, 'capture.jpg');
    final outputPath = p.join(temporaryDirectory.path, 'stored');
    final sourceImage = img.Image(width: 1600, height: 1200);
    File(sourcePath).writeAsBytesSync(img.encodeJpg(sourceImage));

    final result = processImageInIsolate(
      sourcePath: sourcePath,
      destinationDirectoryPath: outputPath,
    );

    expect(File(sourcePath).existsSync(), isFalse);
    expect(File(result.compressedPath).existsSync(), isTrue);
    expect(File(result.thumbnailPath).existsSync(), isTrue);

    final stored = img.decodeImage(
      File(result.compressedPath).readAsBytesSync(),
    );
    final thumbnail = img.decodeImage(
      File(result.thumbnailPath).readAsBytesSync(),
    );
    expect((stored!.width, stored.height), (1080, 1080));
    expect((thumbnail!.width, thumbnail.height), (240, 240));
  });

  test('keeps the source capture when decoding fails', () {
    final sourcePath = p.join(temporaryDirectory.path, 'invalid.jpg');
    final outputPath = p.join(temporaryDirectory.path, 'stored');
    File(sourcePath).writeAsStringSync('not an image');

    expect(
      () => processImageInIsolate(
        sourcePath: sourcePath,
        destinationDirectoryPath: outputPath,
      ),
      throwsFormatException,
    );
    expect(File(sourcePath).existsSync(), isTrue);
  });
}
