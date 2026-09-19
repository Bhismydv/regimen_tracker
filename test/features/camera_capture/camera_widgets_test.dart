import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:regimen_tracker/features/camera_capture/presentation/widgets/alignment_grid.dart';
import 'package:regimen_tracker/features/camera_capture/presentation/widgets/camera_status_view.dart';

void main() {
  testWidgets('camera status explains failure and retries', (tester) async {
    var retryCount = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          backgroundColor: Colors.black,
          body: CameraStatusView(
            icon: Icons.no_photography_outlined,
            title: 'Camera permission required',
            message: 'Enable camera access.',
            onRetry: () => retryCount++,
          ),
        ),
      ),
    );

    expect(find.text('Camera permission required'), findsOneWidget);
    expect(find.text('Enable camera access.'), findsOneWidget);
    await tester.tap(find.byKey(const Key('camera-retry-button')));
    expect(retryCount, 1);
  });

  testWidgets('alignment guide never intercepts camera gestures', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SizedBox.square(dimension: 320, child: AlignmentGrid()),
        ),
      ),
    );

    final guide = find.byKey(const Key('camera-alignment-grid'));
    expect(guide, findsOneWidget);
    expect(tester.widget<IgnorePointer>(guide).ignoring, isTrue);
  });
}
