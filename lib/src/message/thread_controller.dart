import 'package:flutter/material.dart';
import 'message.dart';

import 'thread_service.dart';

List<String> _mockSubscribedThreads = ['threadId1', 'threadId2'];

class ThreadController with ChangeNotifier {
  ThreadController(this._threadService);

  final ThreadService _threadService;

  List<Thread> _threads = [];

  List<Thread> get threads => _threads;

  Future<void> loadThreads() async {
    for (String threadUid in _mockSubscribedThreads) {
      // _threads.add(await _threadService.thread(threadUid));
      _threadService.thread(threadUid).then((value) => _threads.add(value));
    }
    notifyListeners();
  }
}
