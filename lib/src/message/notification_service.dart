import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:skelly/src/debug/debug.dart';

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
      await Future.delayed(const Duration(milliseconds: 50));
    }
  }

  Future<void> unsubscribe(Set<String> threadIds) async {
    for (String threadId in threadIds) {
      FirebaseMessaging.instance.unsubscribeFromTopic(threadId);
      await Future.delayed(const Duration(milliseconds: 50));
    }
  }
}
