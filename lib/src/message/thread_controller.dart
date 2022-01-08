import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'message.dart';

import 'thread_service.dart';

List<String> _mockSubscribedThreads = ['threadId1', 'threadId2'];

class ThreadController with ChangeNotifier {
  ThreadController(this._threadService);

  final ThreadService _threadService;

  Map<String, Thread> _threads = {};

  final Map<String, StreamSubscription> _threadSubscriptions = {};

  // Return thread map as list that can be iterated by the UI
  List<Thread> get threads => _threads.values.toList();

  void subscribeThreads() {
    for (String threadUid in _mockSubscribedThreads) {
      // If new thread, create w/empty messages
      _threads.putIfAbsent(threadUid, () => Thread({}));

      // Keep track of subscriptions and make sure we have a single instance
      // also allows cancelling subscriptions later if needed
      _threadSubscriptions.putIfAbsent(
          threadUid,
          () => _threadService.messageStream(threadUid).listen((newMessage) {
                // Add new messages to the thread and notify the UI
                _threads[threadUid]!
                    .messages
                    .putIfAbsent(newMessage.uid, () => newMessage);
                notifyListeners();
              }));
    }
  }

  void removeThreads(Set<String> threadUids) {
    for (String threadUid in threadUids) {
      _threadSubscriptions.remove(threadUid);
      _threads.remove(threadUid);
    }
    notifyListeners();
  }

  void putToThread(String threadUid, String messageText) {
    _threadService.putMessage(
        threadUid,
        Message(
            uid: 'nan',
            text: messageText,
            author: 'its me!',
            userUid: 'itsMeId',
            timeStamp: Timestamp.now(),
            isTest: true,
            isNew: true));
  }
}
