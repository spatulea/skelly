import 'dart:async';

import 'package:flutter/material.dart';

import 'message.dart';
import 'thread_service.dart';
import 'notification_service.dart';
import '../user/user_service.dart';
import '../debug/debug.dart';

class ThreadController with ChangeNotifier {
  ThreadController(this._userService, this._threadService);

  static const String _className = 'ThreadController';

  final ThreadService _threadService;
  final UserService _userService;
  final _notificationService = NotificationService();

  final Map<String, Thread> _threads = {};

  final Map<String, List<StreamSubscription>> _threadSubscriptions = {};

  // Return thread map as list that can be iterated by the UI
  List<Thread> get threads => _threads.values.toList();

  Future<void> initialize() async {
    _threadService.initialize();
    await _notificationService.initialize();
  }

  void subscribeThreads() {
    const String origin = _className + '.subscribeThreads';

    Set<String> cachedSubscribedThreads = {};
    _userService.subscribedThreads.listen((subscribedThreads) {
      // Find and subscribe to the new threads
      for (String threadUid
          in subscribedThreads.difference(cachedSubscribedThreads)) {
        debug('Adding new thread subscription $threadUid', origin: origin);

        // Create the local empty thread
        _threads.putIfAbsent(threadUid, () => Thread({}, uid: threadUid));

        // create and add the newMessage & removedMessage streams
        _threadSubscriptions.putIfAbsent(
            threadUid,
            () => [
                  // new message stream
                  _threadService
                      .newMessageStream(threadUid)
                      .listen((newMessage) {
                    if (newMessage != null) {
                      // Add new messages to the thread and notify the UI
                      _threads[threadUid]!
                          .messages
                          .putIfAbsent(newMessage.uid!, () => newMessage);
                      notifyListeners();
                    }
                  }),
                  // remove message stream
                  _threadService
                      .removedMessageStream(threadUid)
                      .listen((removedMessage) {
                    if (removedMessage != null) {
                      // Remove message from thread and notify the UI
                      _threads[threadUid]!.messages.remove(removedMessage.uid!);
                      notifyListeners();
                    }
                  })
                ]);

        // Subscribe to notifications for this thread
        _notificationService.subscribe(threadUid);
        // Add the new threads to listener cache
        cachedSubscribedThreads.add(threadUid);
      }

      // Find and cancel subscriptions to old threads
      for (String threadUid
          in cachedSubscribedThreads.difference(subscribedThreads)) {
        debug('Removing old thread subscription $threadUid', origin: origin);
        // Cancel the message subscriptions and remove the thread
        _threadSubscriptions[threadUid]
            ?.forEach((subscription) => subscription.cancel());
        _threadSubscriptions.remove(threadUid);

        // remove the thread local thread cache
        _threads.remove(threadUid);

        // Cancel notification subscription
        _notificationService.unsubscribe(threadUid);

        // remove the threadUid from the listener cache
        cachedSubscribedThreads.remove(threadUid);
      }

      notifyListeners();
    });
  }

  void putToThread(String threadUid, Message message) {
    const String origin = _className + '.putToThread';

    debug('Adding message to thread $threadUid', origin: origin);
    _threadService.putMessage(threadUid, message);
  }

  Future<void> createThread(Message message) async {
    final newThreadUid = await _threadService.createThread(message);
    _userService.subscribeToThread(newThreadUid);
  }

  // TODO condition exists where threadUid is invalid in threads collection
  Future<void> subscribeToThread(String threadUid) async {
    _userService.subscribeToThread(threadUid);
  }

  Future<void> unsubscribeThread(Thread thread) async {
    _userService.unsubscribeFromThread(thread.uid);
  }
}
