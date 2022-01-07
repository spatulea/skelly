import 'package:flutter_test/flutter_test.dart';
import 'package:skelly/src/app.dart';
import 'package:skelly/src/message/thread_controller.dart';
import 'package:skelly/src/message/thread_service.dart';
import 'package:skelly/src/settings/settings_controller.dart';
import 'package:skelly/src/settings/settings_service.dart';
import 'package:flutter/material.dart';

import '../fake_thread_service.dart';

class FakeSettingsService with SettingsService {
  ThemeMode _themeMode = ThemeMode.system;

  /// Fake loading from some external storage.
  @override
  Future<ThemeMode> themeMode() async => _themeMode;

  // Fake writing to some external storage
  @override
  Future<void> updateThemeMode(ThemeMode theme) async {
    _themeMode = theme;
  }
}

void main() {
  group('ServiceController.updateThemeMode should', () {
    test('inform the service of the value', () async {
      final service = FakeSettingsService();
      final controller = SettingsController(service);

      await controller.loadSettings();

      expect(controller.themeMode, ThemeMode.system);
      expect(service._themeMode, ThemeMode.system);

      controller.updateThemeMode(ThemeMode.dark);

      expect(controller.themeMode, ThemeMode.dark);
      expect(service._themeMode, ThemeMode.dark);
    });

    testWidgets('inform the UI of the value', (WidgetTester tester) async {
      final service = FakeSettingsService();
      final controller = SettingsController(service);
      final threadController = ThreadController(FakeThreadService());
      threadController.loadThreads();
      await controller.loadSettings();

      final myApp = MyApp(
        settingsController: controller,
        threadController: threadController,
      );

      await tester.pumpWidget(myApp);
      expect(tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
          ThemeMode.system);

      await controller.updateThemeMode(ThemeMode.dark);
      await tester.pumpWidget(myApp);

      expect(tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
          ThemeMode.dark);
    });
  });
}
