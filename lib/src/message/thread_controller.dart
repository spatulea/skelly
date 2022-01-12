import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'message.dart';

import 'thread_service.dart';
import '../user/user_service.dart';

class ThreadController with ChangeNotifier {
  ThreadController(this._userService, this._threadService);

  final ThreadService _threadService;
  final UserService _userService;

  Map<String, Thread> _threads = {};

  final Map<String, StreamSubscription> _threadSubscriptions = {};

  // Return thread map as list that can be iterated by the UI
  List<Thread> get threads => _threads.values.toList();

  void subscribeThreads() {
    // TODO implement sync (allow removing as well as adding) functionality
    // between the service and controller (maybe clear _threads first?)
    _userService.subscribedThreads.listen((subscribedThreads) {
      // TODO maybe compare _threads and stream content to add/remove _threads
      _threads.clear();
      _threadSubscriptions.clear();
      for (String threadUid in subscribedThreads) {
        // If new thread, create w/empty messages
        // TODO putIfAbsent is not the best solution here
        _threads.putIfAbsent(threadUid, () => Thread({}, uid: threadUid));

        // Keep track of subscriptions and make sure we have a single instance
        // also allows cancelling subscriptions later if needed
        // TODO putIfAbsent is not the best solution here either
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
    });
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
