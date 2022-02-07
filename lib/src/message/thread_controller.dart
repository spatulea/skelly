import 'dart:async';

import 'package:flutter/material.dart';

import 'message.dart';
import 'thread_service.dart';
import '../user/user_service.dart';
import '../debug/debug.dart';

class ThreadController with ChangeNotifier {
  ThreadController(this._userService, this._threadService);

  static const String _className = 'ThreadController';

  final ThreadService _threadService;
  final UserService _userService;

  final Map<String, Thread> _threads = {};

  final Map<String, StreamSubscription> _threadSubscriptions = {};

  // Return thread map as list that can be iterated by the UI
  List<Thread> get threads => _threads.values.toList();

  void initialize() {
    _threadService.initialize();
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

        // create and add the message stream
        _threadSubscriptions.putIfAbsent(
            threadUid,
            () => _threadService.messageStream(threadUid).listen((newMessage) {
                  if (newMessage != null) {
                    // Add new messages to the thread and notify the UI
                    _threads[threadUid]!
                        .messages
                        .putIfAbsent(newMessage.uid!, () => newMessage);
                    notifyListeners();
                  }
                }));
        // Add the new threads to listener cache
        cachedSubscribedThreads.add(threadUid);
      }

      // Find and cancel subscriptions to old threads
      for (String threadUid
          in cachedSubscribedThreads.difference(subscribedThreads)) {
        debug('Removing old thread subscription $threadUid', origin: origin);
        // Cancel the subscription and remove it.
        _threadSubscriptions[threadUid]?.cancel();
        _threadSubscriptions.remove(threadUid);

        // remove the thread local thread cache
        _threads.remove(threadUid);

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
