import 'package:flutter_test/flutter_test.dart';
import 'package:skelly/src/app.dart';
import 'package:skelly/src/message/thread_controller.dart';
import 'package:skelly/src/message/thread_service.dart';
import 'package:skelly/src/settings/settings_controller.dart';
import 'package:skelly/src/settings/settings_service.dart';
import 'package:flutter/material.dart';
import 'package:skelly/src/user/auth_service.dart';
import 'package:skelly/src/user/user_controller.dart';
import 'package:skelly/src/user/user_service.dart';

import '../mock_settings_service.dart';
import '../mock_thread_service.dart';

void main() {
  group('ServiceController.updateThemeMode should', () {
    test('inform the service of the value', () async {
      final service = MockSettingsService();
      final controller = SettingsController(service);

      await controller.loadSettings();

      expect(controller.themeMode, ThemeMode.system);
      expect(await service.themeMode(), ThemeMode.system);

      controller.updateThemeMode(ThemeMode.dark);

      expect(controller.themeMode, ThemeMode.dark);
      expect(await service.themeMode(), ThemeMode.dark);
    });

    testWidgets('inform the UI of the value', (WidgetTester tester) async {
      final settingsService = MockSettingsService();
      final settingsController = SettingsController(settingsService);

      final authService = AuthService();
      final userService = UserService();
      final threadService = ThreadService();

      final threadController = ThreadController(userService, threadService);
      final userController = UserController(userService, authService);

      threadController.subscribeThreads();
      await settingsController.loadSettings();

      final myApp = MyApp(
        settingsController: settingsController,
        threadController: threadController,
        userController: userController,
      );

      await tester.pumpWidget(myApp);
      expect(tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
          ThemeMode.system);

      await settingsController.updateThemeMode(ThemeMode.dark);
      await tester.pumpWidget(myApp);

      expect(tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
          ThemeMode.dark);
    });
  });
}
