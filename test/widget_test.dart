import 'package:flutter_test/flutter_test.dart';
import 'package:regimen_tracker/app/di/app_container.dart';
import 'package:regimen_tracker/main.dart';

void main() {
  test('app is constructed with its dependency container', () async {
    final container = AppContainer();

    final app = MyApp(container: container);

    expect(app.container, same(container));
    await container.dispose();
  });
}
