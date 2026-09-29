import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:regimen_tracker/app/theme/theme_colors.dart';

void main() {
  test('light theme uses the botanical regimen palette', () {
    final theme = RegimenTheme.light();

    expect(theme.brightness, Brightness.light);
    expect(theme.colorScheme.primary, RegimenPalette.botanical);
    expect(theme.scaffoldBackgroundColor, RegimenPalette.ivory);
    expect(
      theme.navigationBarTheme.indicatorColor,
      theme.colorScheme.primaryContainer,
    );
    expect(theme.inputDecorationTheme.filled, isTrue);
  });

  test('dark theme retains accessible semantic contrast', () {
    final theme = RegimenTheme.dark();

    expect(theme.brightness, Brightness.dark);
    expect(theme.colorScheme.primary, RegimenPalette.botanicalDark);
    expect(
      theme.colorScheme.primary.computeLuminance(),
      greaterThan(theme.scaffoldBackgroundColor.computeLuminance()),
    );
    expect(theme.cardTheme.color, theme.colorScheme.surfaceContainerLowest);
  });
}
