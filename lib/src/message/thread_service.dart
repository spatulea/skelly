import 'package:firebase_database/firebase_database.dart';

import 'package:skelly/src/debug/debug.dart';
import 'package:skelly/src/message/message.dart';

class ThreadService {
  static const String _className = 'ThreadService';
  static int _uidSeed = 238976;

  late FirebaseDatabase _messageDb;
  late DatabaseReference _threadsRef;

  static int get _getSeed {
    _uidSeed++;
    return _uidSeed;
  }

  void initialize() {
    _messageDb = FirebaseDatabase.instance;
    _threadsRef = _messageDb.ref('threads');
  }

  Stream<Message?> messageStream(String threadUid) {
    const String origin = _className + '.messageStream';

    var queryRef =
        _threadsRef.child(threadUid).orderByChild('timeStamp').limitToLast(100);

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
    var messageRef = _threadsRef.child(threadUid).push();
    await messageRef.set(message.toJson()).then((_) => debug(
        'Added message ${messageRef.key} to thread $threadUid',
        origin: _className + '.putMessage'));
  }

  Future<String> createThread(Message message) async {
    var newThreadRef = _threadsRef.push();

    await putMessage(newThreadRef.key!, message).then((_) => debug(
        'Created new thread ${newThreadRef.key}',
        origin: _className + '.createThread'));

    return newThreadRef.key!;
  }
}
