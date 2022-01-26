import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:skelly/src/debug/debug.dart';
import 'package:skelly/src/user/auth_service.dart';
import 'package:uni_links/uni_links.dart';
// import 'package:uni_links/uni_links.dart';

import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';
import 'src/user/user_service.dart';
import 'src/user/user_controller.dart';
import 'src/message/thread_controller.dart';
import 'src/message/thread_service.dart';

void main() async {
  const String origin = 'main';
  debug('App Start', origin: origin);
  // Initialize Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  debug('Firebase Initialized', origin: origin);

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

  // Check for link passed at app start-up
  try {
    final Uri? uri = await getInitialUri();
    debug('Got unilink uri $uri', origin: origin);
    if (uri != null) {
      String? threadUid = uri.queryParameters['threadUid'];
      if (threadUid != null) {
        // Add passed threadUid to user's subscriptions
        threadController.subscribeToThread(threadUid);
      }
    }
  } catch (e) {
    debug('Error $e failed to parse initial URI', origin: origin);
  }

  // Attach listener to new links
  uriLinkStream.listen((Uri? uri) {
    debug('Got late link uri $uri', origin: origin);
    if (uri != null) {
      String? threadUid = uri.queryParameters['threadUid'];
      if ((threadUid ?? '') != '') {
        // Add passed threadUid to user's subscriptions
        threadController.subscribeToThread(threadUid!);
      }
    }
  }, onError: (error, stackTrace) {
    debug('Error processing URI $error $stackTrace', origin: origin);
  });

  debug('Service and Controller initialization complete', origin: origin);

  // Run the app and pass in the SettingsController. The app listens to the
  // SettingsController for changes, then passes it further down to the
  // SettingsView.
  runApp(MyApp(
    settingsController: settingsController,
    threadController: threadController,
    userController: userController,
  ));
}
