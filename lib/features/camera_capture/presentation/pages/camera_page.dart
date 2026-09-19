import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:regimen_tracker/app/di/app_container.dart';
import 'package:regimen_tracker/core/image_processing/image_service.dart';
import 'package:regimen_tracker/data/repositories/log_repository_impl.dart';
import 'package:regimen_tracker/features/camera_capture/presentation/widgets/alignment_grid.dart';
import 'package:regimen_tracker/features/camera_capture/presentation/widgets/camera_preview_widget.dart';
import 'package:regimen_tracker/features/camera_capture/presentation/widgets/camera_status_view.dart';
import 'package:regimen_tracker/features/daily_log/presentation/pages/daily_log_page.dart';
import 'package:regimen_tracker/features/timeline/presentation/cubit/timeline_cubit.dart';
import 'package:regimen_tracker/features/timeline/presentation/pages/timeline_page.dart';

enum CameraViewStatus {
  initializing,
  ready,
  permissionDenied,
  unavailable,
  error,
}

class CameraPage extends StatefulWidget {
  final AppContainer container;
  final Future<List<CameraDescription>> Function() loadCameras;
  final VoidCallback? onLogSaved;

  const CameraPage({
    super.key,
    required this.container,
    this.loadCameras = availableCameras,
    this.onLogSaved,
  });

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> with WidgetsBindingObserver {
  CameraController? controller;
  String? lastImagePath;
  bool isCapturing = false;
  bool cameraRouteCovered = false;
  bool showGhost = true;
  bool mirrorGhost = true;
  double ghostOpacity = 0.32;
  CameraViewStatus status = CameraViewStatus.initializing;
  String? cameraErrorMessage;
  int initializationGeneration = 0;
  late final LogRepositoryImpl logRepository;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    logRepository = widget.container.logRepository;
    unawaited(initializeCamera());
    unawaited(loadLastImage());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        if (!cameraRouteCovered) unawaited(initializeCamera());
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        unawaited(releaseCamera());
        break;
    }
  }

  Future<void> initializeCamera() async {
    final generation = ++initializationGeneration;
    final previousController = controller;
    controller = null;

    if (mounted) {
      setState(() {
        status = CameraViewStatus.initializing;
        cameraErrorMessage = null;
      });
    }
    await previousController?.dispose();

    CameraController? nextController;
    try {
      final cameras = await widget.loadCameras();
      final frontCameras = cameras.where(
        (camera) => camera.lensDirection == CameraLensDirection.front,
      );
      if (frontCameras.isEmpty) {
        if (mounted && generation == initializationGeneration) {
          setState(() {
            status = CameraViewStatus.unavailable;
            cameraErrorMessage = 'No front-facing camera was found.';
          });
        }
        return;
      }

      nextController = CameraController(
        frontCameras.first,
        ResolutionPreset.high,
        enableAudio: false,
      );
      await nextController.initialize();
      await nextController.lockCaptureOrientation(DeviceOrientation.portraitUp);

      if (!mounted || generation != initializationGeneration) {
        await nextController.dispose();
        return;
      }

      setState(() {
        controller = nextController;
        status = CameraViewStatus.ready;
      });
    } on CameraException catch (error) {
      await nextController?.dispose();
      if (!mounted || generation != initializationGeneration) return;
      setState(() {
        status = _isPermissionError(error)
            ? CameraViewStatus.permissionDenied
            : CameraViewStatus.error;
        cameraErrorMessage = error.description;
      });
    } catch (error) {
      await nextController?.dispose();
      if (!mounted || generation != initializationGeneration) return;
      setState(() {
        status = CameraViewStatus.error;
        cameraErrorMessage = error.toString();
      });
    }
  }

  Future<void> releaseCamera() async {
    initializationGeneration++;
    final currentController = controller;
    controller = null;
    if (mounted) {
      setState(() => status = CameraViewStatus.initializing);
    }
    await currentController?.dispose();
  }

  Future<void> loadLastImage() async {
    try {
      final lastLog = await logRepository.getMostRecentLog();
      final path = lastLog?.imagePath;
      final exists = path != null && await File(path).exists();

      if (mounted) {
        setState(() => lastImagePath = exists ? path : null);
      }
    } catch (_) {
      if (mounted) {
        setState(() => lastImagePath = null);
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    initializationGeneration++;
    unawaited(controller?.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('Align today\'s photo'),
      ),
      body: SafeArea(child: _buildBody()),
    );
  }

  Widget _buildBody() {
    if (status == CameraViewStatus.initializing) {
      return const Center(child: CircularProgressIndicator());
    }
    if (status == CameraViewStatus.permissionDenied) {
      return CameraStatusView(
        icon: Icons.no_photography_outlined,
        title: 'Camera permission required',
        message:
            cameraErrorMessage ??
            'Enable camera access in device settings, then try again.',
        onRetry: initializeCamera,
      );
    }
    if (status == CameraViewStatus.unavailable) {
      return CameraStatusView(
        icon: Icons.camera_front_outlined,
        title: 'Front camera unavailable',
        message:
            cameraErrorMessage ??
            'A front-facing camera is required for consistent tracking.',
        onRetry: initializeCamera,
      );
    }
    if (status == CameraViewStatus.error) {
      return CameraStatusView(
        icon: Icons.error_outline,
        title: 'Camera could not start',
        message:
            cameraErrorMessage ?? 'Please try initializing the camera again.',
        onRetry: initializeCamera,
      );
    }

    final cameraController = controller;
    if (cameraController == null || !cameraController.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    final hasGhost = lastImagePath != null;
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(24, 12, 24, 16),
          child: Text(
            'Match your eyes to the line and keep your face inside the oval.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70),
          ),
        ),
        Expanded(
          child: Center(
            child: AspectRatio(
              aspectRatio: 1,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CameraPreviewWidget(controller: cameraController),
                  if (hasGhost && showGhost)
                    IgnorePointer(
                      child: Opacity(
                        opacity: ghostOpacity,
                        child: Transform.flip(
                          flipX: mirrorGhost,
                          child: Image.file(
                            File(lastImagePath!),
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => const SizedBox.shrink(),
                          ),
                        ),
                      ),
                    ),
                  const AlignmentGrid(),
                ],
              ),
            ),
          ),
        ),
        _buildControls(hasGhost),
      ],
    );
  }

  Widget _buildControls(bool hasGhost) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (hasGhost)
            Row(
              children: [
                IconButton(
                  tooltip: showGhost
                      ? 'Hide previous photo'
                      : 'Show previous photo',
                  color: Colors.white,
                  onPressed: () => setState(() => showGhost = !showGhost),
                  icon: Icon(
                    showGhost ? Icons.visibility : Icons.visibility_off,
                  ),
                ),
                IconButton(
                  tooltip: 'Flip previous photo',
                  color: Colors.white,
                  onPressed: showGhost
                      ? () => setState(() => mirrorGhost = !mirrorGhost)
                      : null,
                  icon: const Icon(Icons.flip),
                ),
                Expanded(
                  child: Slider(
                    value: ghostOpacity,
                    min: 0.1,
                    max: 0.65,
                    divisions: 11,
                    label: '${(ghostOpacity * 100).round()}%',
                    onChanged: showGhost
                        ? (value) => setState(() => ghostOpacity = value)
                        : null,
                  ),
                ),
              ],
            ),
          Semantics(
            button: true,
            label: isCapturing ? 'Processing photo' : 'Take aligned photo',
            child: FloatingActionButton.large(
              key: const Key('camera-capture-button'),
              onPressed: isCapturing ? null : captureImage,
              child: isCapturing
                  ? const SizedBox.square(
                      dimension: 28,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.camera_alt),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> captureImage() async {
    final cameraController = controller;
    if (cameraController == null ||
        !cameraController.value.isInitialized ||
        cameraController.value.isTakingPicture ||
        isCapturing) {
      return;
    }

    setState(() => isCapturing = true);
    var shouldRestoreCamera = true;

    try {
      final image = await cameraController.takePicture();
      final result = await ImageService.processImage(image.path);

      if (!mounted) return;
      cameraRouteCovered = true;
      await releaseCamera();
      if (!mounted) return;

      final wasSaved = await Navigator.of(context).push<bool>(
        MaterialPageRoute(
          builder: (_) => DailyLogPage(
            imagePath: result.compressedPath,
            thumbnailPath: result.thumbnailPath,
            container: widget.container,
          ),
        ),
      );

      if (wasSaved == true) {
        await loadLastImage();
        if (!mounted) return;
        if (widget.onLogSaved case final onLogSaved?) {
          shouldRestoreCamera = false;
          onLogSaved();
        } else {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => TimelinePage(
                cubit: TimelineCubit(
                  widget.container.logRepository,
                  widget.container.habitRepository,
                ),
              ),
            ),
          );
        }
      } else {
        await ImageService.deleteProcessedImages(
          imagePath: result.compressedPath,
          thumbnailPath: result.thumbnailPath,
        );
      }
    } on CameraException catch (error) {
      if (!mounted) return;
      _showCaptureError(
        error.description ?? 'The camera could not take a photo.',
      );
    } catch (error) {
      if (!mounted) return;
      _showCaptureError('Could not process the photo: $error');
    } finally {
      cameraRouteCovered = false;
      if (mounted && shouldRestoreCamera) {
        await initializeCamera();
      }
      if (mounted) {
        setState(() => isCapturing = false);
      }
    }
  }

  void _showCaptureError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  bool _isPermissionError(CameraException error) {
    return error.code == 'CameraAccessDenied' ||
        error.code == 'CameraAccessDeniedWithoutPrompt' ||
        error.code == 'CameraAccessRestricted';
  }
}
