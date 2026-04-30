import 'package:flutter/material.dart';
import 'package:regimen_tracker/app/di/app_container.dart';
import 'package:regimen_tracker/features/camera_capture/presentation/pages/camera_page.dart';

void main() {
  final container = AppContainer();

  runApp(MyApp(container: container));
}

class MyApp extends StatelessWidget {
  final AppContainer container;

  const MyApp({super.key, required this.container});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: CameraPage(container: container),
    );
  }
}

