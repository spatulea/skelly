import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:skelly/src/debug/debug.dart';
import 'package:skelly/src/user/auth_service.dart';

import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';
import 'src/user/user_service.dart';
import 'src/user/user_controller.dart';
import 'src/message/thread_controller.dart';
import 'src/message/thread_service.dart';

void main() async {
  const String _origin = 'main';
  debug('App Start', origin: _origin);
  // Initialize Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  debug('Firebase Initialized', origin: _origin);

  // Set up the Services and Controllers we need
  final settingsController = SettingsController(SettingsService());
  final userService = UserService();
  final userController = UserController(userService, AuthService());
  final threadController = ThreadController(userService, ThreadService());

  await userController.initialize();
  threadController.initialize();
  threadController.subscribeThreads();

  // Load the user's preferred theme while the splash screen is displayed.
  // This prevents a sudden theme change when the app is first displayed.
  await settingsController.loadSettings();

  // Run the app and pass in the SettingsController. The app listens to the
  // SettingsController for changes, then passes it further down to the
  // SettingsView.
  runApp(MyApp(
    settingsController: settingsController,
    threadController: threadController,
    userController: userController,
  ));
}
