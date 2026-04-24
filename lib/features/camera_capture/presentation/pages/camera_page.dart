import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:regimen_tracker/data/repositories/log_repository_impl.dart';
import 'package:regimen_tracker/features/daily_log/presentation/pages/daily_log_page.dart';
import '../../../../core/image_processing/image_service.dart';
import '../../../../data/database/app_database.dart' as db;
import '../../../../domain/entities/daily_log.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController? controller;
  String? lastImagePath;
  late LogRepositoryImpl logRepository;
  late db.AppDatabase database;
  @override
  void initState() {
    super.initState();
    initCamera();

    database = db.AppDatabase();
    logRepository = LogRepositoryImpl(database);

    loadLastImage();
  }

  Future<void> initCamera() async {
    final cameras = await availableCameras();

    final frontCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
    );

    controller = CameraController(
      frontCamera,
      ResolutionPreset.high,
      enableAudio: false,
    );

    await controller!.initialize();

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> loadLastImage() async {
    final logs = await logRepository.getLogs();

    if (logs.isNotEmpty) {
      final lastLog = logs.last;

      setState(() {
        lastImagePath = lastLog.imagePath;
      });
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller!.value.isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: Stack(
        children: [
          CameraPreview(controller!),

          if (lastImagePath != null)
            Opacity(
              opacity: 0.3,
              child: Image.file(
                File(lastImagePath!),
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: FloatingActionButton(
                onPressed: () async {
                  final navigator = Navigator.of(context);

                  final image = await controller!.takePicture();
                  final result = await ImageService.processImage(image.path);

                  if (!mounted) return;

                  navigator.push(
                    MaterialPageRoute(
                      builder: (_) =>
                          DailyLogPage(imagePath: result.compressedPath),
                    ),
                  );
                },
                /* onPressed: () async {
                  final image = await controller!.takePicture();

                  final result = await ImageService.processImage(image.path);

                  final now = DateTime.now();

                  await logRepository.addDailyLog(
                    DailyLog(
                        date: DateTime(now.year, now.month, now.day),
                        imagePath: result.compressedPath,
                      thumbnailPath: result.thumbnailPath,
                    ),
                  );

                  setState(() {
                    lastImagePath = result.compressedPath;
                  });
                },*/
                child: const Icon(Icons.camera),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
