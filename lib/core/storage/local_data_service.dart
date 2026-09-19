import 'dart:convert';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:regimen_tracker/domain/entities/timeline_log.dart';
import 'package:regimen_tracker/domain/repositories/habit_repository.dart';
import 'package:regimen_tracker/domain/repositories/log_repository.dart';

typedef DocumentsDirectoryProvider = Future<Directory> Function();

class StorageReport {
  final int imageCount;
  final int imageBytes;
  final List<String> orphanPaths;
  final int orphanBytes;
  final int backupCount;
  final int backupBytes;

  const StorageReport({
    required this.imageCount,
    required this.imageBytes,
    required this.orphanPaths,
    required this.orphanBytes,
    required this.backupCount,
    required this.backupBytes,
  });

  int get orphanCount => orphanPaths.length;
}

class BackupResult {
  final String path;
  final int bytes;
  final int imageCount;

  const BackupResult({
    required this.path,
    required this.bytes,
    required this.imageCount,
  });
}

class CleanupResult {
  final int deletedFiles;
  final int recoveredBytes;

  const CleanupResult({
    required this.deletedFiles,
    required this.recoveredBytes,
  });
}

class LocalDataService {
  final LogRepository logRepository;
  final HabitRepository habitRepository;
  final DocumentsDirectoryProvider documentsDirectoryProvider;

  LocalDataService({
    required this.logRepository,
    required this.habitRepository,
    this.documentsDirectoryProvider = getApplicationDocumentsDirectory,
  });

  Future<StorageReport> inspectStorage() async {
    final documents = await documentsDirectoryProvider();
    final imageDirectory = Directory(p.join(documents.path, 'regimen_images'));
    final backupDirectory = Directory(
      p.join(documents.path, 'regimen_exports'),
    );
    final referencedPaths = await _referencedImagePaths();
    final imageFiles = await _filesIn(imageDirectory);
    final backupFiles = await _filesIn(backupDirectory);
    final orphanFiles = imageFiles.where((file) {
      return !referencedPaths.contains(_normalizedPath(file.path));
    }).toList();

    return StorageReport(
      imageCount: imageFiles.length,
      imageBytes: await _totalBytes(imageFiles),
      orphanPaths: orphanFiles.map((file) => file.path).toList(),
      orphanBytes: await _totalBytes(orphanFiles),
      backupCount: backupFiles.length,
      backupBytes: await _totalBytes(backupFiles),
    );
  }

  Future<CleanupResult> deleteOrphanedImages() async {
    final report = await inspectStorage();
    var deletedFiles = 0;
    var recoveredBytes = 0;

    for (final path in report.orphanPaths) {
      final file = File(path);
      try {
        final length = await file.length();
        await file.delete();
        deletedFiles++;
        recoveredBytes += length;
      } on FileSystemException {
        // Continue safely; a later scan will report anything still present.
      }
    }
    return CleanupResult(
      deletedFiles: deletedFiles,
      recoveredBytes: recoveredBytes,
    );
  }

  Future<BackupResult> createBackup() async {
    final documents = await documentsDirectoryProvider();
    final backupDirectory = Directory(
      p.join(documents.path, 'regimen_exports'),
    );
    await backupDirectory.create(recursive: true);
    final habits = await habitRepository.getAllHabits();
    final timeline = await logRepository.getTimelineLogs();
    final timestamp = DateTime.now().toUtc();
    final fileStamp = timestamp.toIso8601String().replaceAll(':', '-');
    final backupPath = p.join(
      backupDirectory.path,
      'regimen_backup_$fileStamp.zip',
    );
    final archivedImages = <String, String>{};

    for (final entry in timeline) {
      final date = _dateKey(entry.log.date);
      _registerImage(
        archivedImages,
        entry.log.imagePath,
        'images/${date}_image${p.extension(entry.log.imagePath)}',
      );
      final thumbnailPath = entry.log.thumbnailPath;
      if (thumbnailPath != null) {
        _registerImage(
          archivedImages,
          thumbnailPath,
          'images/${date}_thumbnail${p.extension(thumbnailPath)}',
        );
      }
    }

    final manifest = <String, Object?>{
      'format': 'regimen_tracker_backup',
      'version': 1,
      'exportedAtUtc': timestamp.toIso8601String(),
      'habits': habits
          .map(
            (habit) => {
              'id': habit.id,
              'name': habit.name,
              'category': habit.category.name,
              'measurementType': habit.measurementType.name,
              'intensityScaleMax': habit.intensityScaleMax,
              'isActive': habit.isActive,
              'colorValue': habit.colorValue,
            },
          )
          .toList(),
      'dailyLogs': timeline
          .map((entry) => _timelineJson(entry, archivedImages))
          .toList(),
    };
    final manifestBytes = utf8.encode(
      const JsonEncoder.withIndent('  ').convert(manifest),
    );

    final encoder = ZipFileEncoder();
    try {
      encoder.create(backupPath);
      encoder.addArchiveFile(
        ArchiveFile('regimen_backup.json', manifestBytes.length, manifestBytes),
      );
      for (final image in archivedImages.entries) {
        final file = File(image.key);
        if (await file.exists()) {
          await encoder.addFile(file, image.value, ZipFileEncoder.store);
        }
      }
      await encoder.close();
    } catch (_) {
      try {
        await encoder.close();
      } catch (_) {
        // Preserve the original failure.
      }
      final partialBackup = File(backupPath);
      if (await partialBackup.exists()) await partialBackup.delete();
      rethrow;
    }

    final backupFile = File(backupPath);
    return BackupResult(
      path: backupPath,
      bytes: await backupFile.length(),
      imageCount: archivedImages.keys
          .where((path) => File(path).existsSync())
          .length,
    );
  }

  Future<Set<String>> _referencedImagePaths() async {
    final logs = await logRepository.getLogs();
    return {
      for (final log in logs) _normalizedPath(log.imagePath),
      for (final log in logs)
        if (log.thumbnailPath != null) _normalizedPath(log.thumbnailPath!),
    };
  }

  Map<String, Object?> _timelineJson(
    TimelineLog entry,
    Map<String, String> archivedImages,
  ) {
    final log = entry.log;
    return {
      'date': _dateKey(log.date),
      'imageFile': archivedImages[_normalizedPath(log.imagePath)],
      'thumbnailFile': log.thumbnailPath == null
          ? null
          : archivedImages[_normalizedPath(log.thumbnailPath!)],
      'notes': log.notes,
      'conditionTag': log.conditionTag?.name,
      'irritationScore': log.irritationScore,
      'oilinessScore': log.oilinessScore,
      'habitEntries': entry.habitEntries
          .map(
            (habitEntry) => {
              'id': habitEntry.id,
              'habitId': habitEntry.habitId,
              'value': habitEntry.value,
            },
          )
          .toList(),
    };
  }

  void _registerImage(
    Map<String, String> images,
    String sourcePath,
    String archivePath,
  ) {
    images.putIfAbsent(_normalizedPath(sourcePath), () => archivePath);
  }

  Future<List<File>> _filesIn(Directory directory) async {
    if (!await directory.exists()) return [];
    return directory
        .list(recursive: true, followLinks: false)
        .where((entry) => entry is File)
        .cast<File>()
        .toList();
  }

  Future<int> _totalBytes(List<File> files) async {
    var total = 0;
    for (final file in files) {
      try {
        total += await file.length();
      } on FileSystemException {
        // Ignore files removed while the scan is running.
      }
    }
    return total;
  }

  String _normalizedPath(String path) => p.normalize(File(path).absolute.path);

  String _dateKey(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';
}
