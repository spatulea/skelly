import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:skelly/src/debug/debug.dart';
import 'message.dart';

import 'thread_service.dart';
import '../user/user_service.dart';

class ThreadController with ChangeNotifier {
  ThreadController(this._userService, this._threadService);

  static const String _className = 'ThreadController';

  final ThreadService _threadService;
  final UserService _userService;

  Map<String, Thread> _threads = {};

  final Map<String, StreamSubscription> _threadSubscriptions = {};

  // Return thread map as list that can be iterated by the UI
  List<Thread> get threads => _threads.values.toList();

  void subscribeThreads() {
    const String _origin = _className + '.subscribeThreads';

    Set<String> cachedSubscribedThreads = {};
    _userService.subscribedThreads.listen((subscribedThreads) {
      // Find and subscribe to the new threads
      for (String threadUid
          in subscribedThreads.difference(cachedSubscribedThreads)) {
        debug('Adding new thread subscription $threadUid', origin: _origin);

        // Create the local empty thread
        _threads.putIfAbsent(threadUid, () => Thread({}, uid: threadUid));

        // create and add the message stream
        _threadSubscriptions.putIfAbsent(
            threadUid,
            () => _threadService.messageStream(threadUid).listen((newMessage) {
                  // Add new messages to the thread and notify the UI
                  _threads[threadUid]!
                      .messages
                      .putIfAbsent(newMessage.uid, () => newMessage);
                  notifyListeners();
                }));
        // Add the new threads to listener cache
        cachedSubscribedThreads.add(threadUid);
      }

      // Find and cancel subscriptions to old threads
      for (String threadUid
          in cachedSubscribedThreads.difference(subscribedThreads)) {
        debug('Removing old thread subscription $threadUid', origin: _origin);
        // Cancel the subscription and remove it.
        _threadSubscriptions[threadUid]?.cancel();
        _threadSubscriptions.remove(threadUid);

        // remove the thread local thread cache
        _threads.remove(threadUid);

        // remove the threadUid from the listener cache
        cachedSubscribedThreads.remove(threadUid);
      }
    });
  }

  void removeThreads(Set<String> threadUids) {
    const String _origin = _className + '.removeThreads';
    for (String threadUid in threadUids) {
      _threadSubscriptions.remove(threadUid);
      _threads.remove(threadUid);
    }
    notifyListeners();
  }

  void putToThread(String threadUid, String messageText) {
    const String _origin = _className + '.putToThread';

    debug('Adding message to thread $threadUid', origin: _origin);
    _threadService.putMessage(
        threadUid,
        Message(
            uid: '',
            text: messageText,
            author: 'its me!',
            userUid: 'itsMeId',
            timeStamp: Timestamp.now(),
            isTest: true,
            isNew: true));
  }

  Future<void> createThread(Message message) async {
    final newThreadUid = await _threadService.createThread(message);
    _userService.subscribeToThread(newThreadUid);
  }
}
