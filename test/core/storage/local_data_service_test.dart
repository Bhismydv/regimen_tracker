import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:regimen_tracker/app/di/app_container.dart';
import 'package:regimen_tracker/core/storage/local_data_service.dart';
import 'package:regimen_tracker/data/database/app_database.dart'
    show AppDatabase;
import 'package:regimen_tracker/domain/entities/daily_log.dart';
import 'package:regimen_tracker/domain/entities/habit.dart';
import 'package:regimen_tracker/domain/entities/habit_log_entry.dart';
import 'package:regimen_tracker/domain/enums/habit_category.dart';
import 'package:regimen_tracker/domain/enums/measurement_type.dart';

void main() {
  late Directory documents;
  late AppContainer container;
  late LocalDataService service;

  setUp(() async {
    documents = await Directory.systemTemp.createTemp('regimen-storage-test-');
    container = AppContainer(
      database: AppDatabase.forTesting(NativeDatabase.memory()),
    );
    service = LocalDataService(
      logRepository: container.logRepository,
      habitRepository: container.habitRepository,
      documentsDirectoryProvider: () async => documents,
    );
  });

  tearDown(() async {
    await container.dispose();
    if (await documents.exists()) {
      await documents.delete(recursive: true);
    }
  });

  test('reports and deletes only image files not referenced by logs', () async {
    final fixture = await _seedFixture(documents, container);

    final report = await service.inspectStorage();

    expect(report.imageCount, 3);
    expect(report.imageBytes, 12);
    expect(report.orphanCount, 1);
    expect(report.orphanBytes, 5);
    expect(report.orphanPaths, [fixture.orphan.path]);

    final result = await service.deleteOrphanedImages();

    expect(result.deletedFiles, 1);
    expect(result.recoveredBytes, 5);
    expect(await fixture.orphan.exists(), isFalse);
    expect(await fixture.image.exists(), isTrue);
    expect(await fixture.thumbnail.exists(), isTrue);
  });

  test('creates a versioned JSON ZIP with referenced images', () async {
    await _seedFixture(documents, container);

    final result = await service.createBackup();
    final archive = ZipDecoder().decodeBytes(
      await File(result.path).readAsBytes(),
    );
    final files = {for (final file in archive.files) file.name: file};

    expect(result.imageCount, 2);
    expect(files.keys, contains('regimen_backup.json'));
    expect(files.keys, contains('images/2026-09-19_image.jpg'));
    expect(files.keys, contains('images/2026-09-19_thumbnail.jpg'));
    expect(files.keys.any((name) => name.contains('orphan')), isFalse);

    final manifest =
        jsonDecode(utf8.decode(files['regimen_backup.json']!.readBytes()!))
            as Map<String, dynamic>;
    expect(manifest['format'], 'regimen_tracker_backup');
    expect(manifest['version'], 1);
    expect(manifest['habits'], hasLength(1));
    final logs = manifest['dailyLogs'] as List<dynamic>;
    expect(logs, hasLength(1));
    expect(logs.single['imageFile'], 'images/2026-09-19_image.jpg');
    expect(logs.single['thumbnailFile'], 'images/2026-09-19_thumbnail.jpg');
    expect(logs.single['habitEntries'], hasLength(1));

    final report = await service.inspectStorage();
    expect(report.backupCount, 1);
    expect(report.backupBytes, greaterThan(0));
  });
}

Future<_Fixture> _seedFixture(
  Directory documents,
  AppContainer container,
) async {
  final imageDirectory = Directory(p.join(documents.path, 'regimen_images'));
  await imageDirectory.create(recursive: true);
  final image = await File(
    p.join(imageDirectory.path, 'photo.jpg'),
  ).writeAsBytes([1, 2, 3, 4]);
  final thumbnail = await File(
    p.join(imageDirectory.path, 'photo_thumb.jpg'),
  ).writeAsBytes([5, 6, 7]);
  final orphan = await File(
    p.join(imageDirectory.path, 'abandoned.jpg'),
  ).writeAsBytes([8, 9, 10, 11, 12]);
  const habit = Habit(
    id: 'cold-therapy',
    name: 'Cold therapy',
    category: HabitCategory.treatment,
    measurementType: MeasurementType.duration,
    intensityScaleMax: 10,
    isActive: true,
    colorValue: 0xFF2196F3,
  );
  final date = DateTime(2026, 9, 19);
  await container.habitRepository.addHabit(habit);
  await container.logRepository.saveDailyLogWithEntries(
    DailyLog(
      date: date,
      imagePath: image.path,
      thumbnailPath: thumbnail.path,
      notes: 'Test log',
      irritationScore: 2,
      oilinessScore: 4,
    ),
    [HabitLogEntry(id: 'entry-1', habitId: habit.id, logDate: date, value: 10)],
  );
  return _Fixture(image: image, thumbnail: thumbnail, orphan: orphan);
}

class _Fixture {
  final File image;
  final File thumbnail;
  final File orphan;

  const _Fixture({
    required this.image,
    required this.thumbnail,
    required this.orphan,
  });
}
