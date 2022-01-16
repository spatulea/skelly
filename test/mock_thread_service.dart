import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart' show Timestamp;
import 'package:skelly/src/debug/debug.dart';
import 'package:skelly/src/message/message.dart';
import 'package:skelly/src/message/thread_service.dart';

// Mock of the firestore database as a JSON containing threads that contain
// messages
Map<String, Map<String, dynamic>> _mockThreadData = {
  'threadId1': {
    'messageUid1': {
      'author': 'author1',
      'userUid': 'userUid1',
      'timeStamp': Timestamp.now(),
      'text':
          'some first message text that is very long and may need multiple lines and may cause issues with overflow if not controlled to take up less space than this will accomodate this is strange'
    },
    'messageUid2': {
      'author': 'author1',
      'userUid': 'userUid1',
      'timeStamp': Timestamp.now(),
      'text':
          'some second message text that is mid size in length so as to help me correctly size the bubble',
    },
    'messageUid3': {
      'author': 'author1',
      'userUid': 'userUid1',
      'timeStamp': Timestamp.now(),
      'text': 'some third message text',
    },
  },
  'threadId2': {
    'messageUid1': {
      'author': 'author1',
      'userUid': 'userUid1',
      'timeStamp': Timestamp.now(),
      'text':
          'some first message text that is very long and may need multiple lines and may cause issues with overflow if not controlled to take up less space than this will accomodate this is strange'
    },
    'messageUid2': {
      'author': 'author1',
      'userUid': 'userUid1',
      'timeStamp': Timestamp.now(),
      'text':
          'some second message text that is mid size in length so as to help me correctly size the bubble',
    }
  },
  'threadId3': {
    'messageUid1': {
      'author': 'author1',
      'userUid': 'userUid1',
      'timeStamp': Timestamp.now(),
      'text':
          'some first message text that is very long and may need multiple lines and may cause issues with overflow if not controlled to take up less space than this will accomodate this is strange'
    }
  },
};

class MockThreadService implements ThreadService {
  static const String _className = 'MockThreadService';
  static int _uidSeed = 238976;

  static int get _getSeed {
    _uidSeed++;
    return _uidSeed;
  }

  @override
  Stream<Message> messageStream(String threadUid) async* {
    // cancel the stream if the threadUid doesn't exist
    if (!_mockThreadData.containsKey(threadUid)) return;

    // Occasionally check for new messages and put them on the stream
    // this is hokey but will eventually be replaced by Firebase
    // and testing won't need to be this fancy
    Set<String> cachedKeys = {};
    while (true) {
      await Future<void>.delayed(Duration(milliseconds: Random().nextInt(100)));
      var newKeys = _mockThreadData[threadUid]!.keys.toSet();
      for (String key in newKeys.difference(cachedKeys)) {
        await Future<void>.delayed(
            Duration(milliseconds: Random().nextInt(100)));
        cachedKeys.add(key);
        yield Message.fromJson(_mockThreadData[threadUid]![key], key);
      }
    }
  }

  @override
  Future<void> putMessage(String threadUid, Message message) async {
    if (!_mockThreadData.containsKey(threadUid)) return;

    _mockThreadData[threadUid]!.putIfAbsent(
        'messageUid' + _getSeed.toString(), () => message.toJson());
  }

  @override
  Future<String> createThread(Message message) async {
    final String newThreadUid = _getSeed.toString();
    _mockThreadData.putIfAbsent(
        newThreadUid, () => {_getSeed.toString(): message.toJson()});
    debug('Created thread: ${_mockThreadData[newThreadUid]}',
        origin: _className + '.createThread');
    return newThreadUid;
  }
}
