import 'dart:async';

import 'package:flutter/material.dart';
import 'package:regimen_tracker/app/app.dart';
import 'package:regimen_tracker/app/di/app_container.dart';
import 'package:regimen_tracker/app/theme/theme_colors.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp(container: AppContainer()));
}

class MyApp extends StatefulWidget {
  final AppContainer container;

  const MyApp({super.key, required this.container});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void dispose() {
    unawaited(widget.container.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Regimen Tracker',
      debugShowCheckedModeBanner: false,
      theme: RegimenTheme.light(),
      home: AppShell(container: widget.container),
    );
  }
}
