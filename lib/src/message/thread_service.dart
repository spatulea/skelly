import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart' show Timestamp;
import 'package:skelly/src/debug/debug.dart';
import 'package:skelly/src/message/message.dart';

// For now, let's pretend the data is static and not a stream subscription
// as the future firestore implementation is likely to be. So we can mock
// the firestore database as a JSON containing threads that contain messages
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

class ThreadService {
  static const String _className = 'ThreadService';
  static int _uidSeed = 238976;

  static int get _getSeed {
    _uidSeed++;
    return _uidSeed;
  }

  Stream<Message> messageStream(String threadUid) async* {
    // cancel the stream if the threadUid doesn't exist
    if (!_mockThreadData.containsKey(threadUid)) return;

    // Occasionally check for new messages and put them on the stream
    // this is hokey but will eventually be replaced by Firebase
    // and testing won't need to be this fancy
    while (true) {
      await Future<void>.delayed(Duration(milliseconds: Random().nextInt(100)));
      var keys = _mockThreadData[threadUid]!.keys.toList();
      for (String key in keys) {
        await Future<void>.delayed(
            Duration(milliseconds: Random().nextInt(100)));
        yield Message.fromJson(_mockThreadData[threadUid]!.remove(key), key);
      }
    }
  }

  Future<void> putMessage(String threadUid, Message message) async {
    if (!_mockThreadData.containsKey(threadUid)) return;

    _mockThreadData[threadUid]!.putIfAbsent(
        'messageUid' + _getSeed.toString(), () => message.toJson());
  }

  Future<String> createThread(Message message) async {
    final String newThreadUid = _getSeed.toString();
    _mockThreadData[newThreadUid] = {_getSeed.toString(): message.toJson()};
    debug('Created thread: ${_mockThreadData[newThreadUid]}',
        origin: _className + '.createThread');
    return newThreadUid;
  }
}
