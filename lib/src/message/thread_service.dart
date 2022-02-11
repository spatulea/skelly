import 'package:firebase_database/firebase_database.dart';

import '../debug/debug.dart';
import '../message/message.dart';

class ThreadService {
  static const String _className = 'ThreadService';

  late FirebaseDatabase _messageDb;
  late DatabaseReference _threadsRef;

  void initialize() {
    _messageDb = FirebaseDatabase.instance;
    _threadsRef = _messageDb.ref('threads');
  }

  Stream<Message?> messageStream(String threadUid) {
    const String origin = _className + '.messageStream';

    // query Realtime Database for last n messages in thread
    var queryRef = _threadsRef
        .child(threadUid)
        .child('messages')
        .orderByChild('timeStamp')
        .limitToLast(100);

    // create a transform stream of messages in the thread to convert JSON data
    // into message objects
    return queryRef.onChildAdded.map((event) {
      Message? newMessage;
      if (event.snapshot.exists) {
        try {
          newMessage = Message.fromJson(
              event.snapshot.value as Map<dynamic, dynamic>,
              event.snapshot.key);
        } catch (e) {
          debug('Error $e from $threadUid stream', origin: origin);
        }
        return newMessage;
      }
    });
  }

  Future<void> putMessage(String threadUid, Message message) async {
    // TODO Should I check the thread exists?

    // Get new uuid from message thread (this is done with local time,
    // no remote connection)
    var messageRef = _threadsRef.child(threadUid).child('messages').push();

    // add message contents to the uuid
    await messageRef.set(message.toJson()).then((_) => debug(
        'Added message ${messageRef.key} to thread $threadUid',
        origin: _className + '.putMessage'));
  }

  Future<String> createThread(Message message) async {
    // Get new thread uuid
    var newThreadRef = _threadsRef.push();

    await newThreadRef.set({
      'authorName': message.authorName,
      'authorUid': message.authorUid,
      'timeStamp': ServerValue.timestamp
    }).then((_) => debug('Created new thread ${newThreadRef.key}',
        origin: _className + '.createThread'));

    // add message contents to new thread
    await putMessage(newThreadRef.key!, message);

    return newThreadRef.key!;
  }
}
