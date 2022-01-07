import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skelly/src/message/message.dart';
import 'package:skelly/src/message/thread_service.dart' show ThreadService;

Map<String, dynamic> _mockThreadData = {
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

class FakeThreadService with ThreadService {
  @override
  Future<Thread> thread(String threadUid) async {
    List<Message> _threadMessageList = [];

    _mockThreadData[threadUid].forEach((key, value) {
      _threadMessageList.add(Message.fromJson(value));
    });

    return (Thread(_threadMessageList, threadUid: threadUid));
  }
}
