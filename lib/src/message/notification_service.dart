import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:skelly/src/debug/debug.dart';

// Notification handler when app is in background
Future<void> _messagingBackgroundHandler(RemoteMessage message) async {
  print(
      'MessagingService._messagingBackgroundHandler: got background message: ${message.messageId}:${message.notification?.title}:${message.notification?.body}');
}

class NotificationService {
  static const _className = 'NotificationService';

  Future<void> initialize() async {
    const origin = _className + '.initialize';
    debug(
        'FCM token: ' +
            (await FirebaseMessaging.instance.getToken() ?? 'nullFcmToken'),
        origin: origin);

    NotificationSettings settings =
        await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    debug('Granted notification permissing: ${settings.authorizationStatus}',
        origin: origin);

    // Handler foreground message stream
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debug(
          'got foreground message: ${message.messageId}:${message.notification?.title}:${message.notification?.body}',
          origin: origin + '.onMessage');
    });

    // Register callback for background notifications
    FirebaseMessaging.onBackgroundMessage(_messagingBackgroundHandler);

    // Subscribe to generic topics
    FirebaseMessaging.instance.subscribeToTopic('general');
  }

  Future<void> subscribe(Set<String> threadIds) async {
    for (String threadId in threadIds) {
      await FirebaseMessaging.instance.subscribeToTopic(threadId);
      await Future.delayed(Duration(milliseconds: 40 + Random().nextInt(10)));
    }
  }

  Future<void> unsubscribe(Set<String> threadIds) async {
    for (String threadId in threadIds) {
      FirebaseMessaging.instance.unsubscribeFromTopic(threadId);
      await Future.delayed(Duration(milliseconds: 40 + Random().nextInt(10)));
    }
  }
}
