import 'package:flutter_test/flutter_test.dart';
import 'package:skelly/src/message/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart' show Timestamp;

void main() {
  final Map<dynamic, dynamic> testJson = {
    // 'uid': 'testUid',
    'text': 'testText',
    'author': 'testAuthor',
    'userUid': 'testUserUid',
    'timeStamp': 1642398059739,
  };
  group('Message should', () {
    // test('create from constructor', () {});
    test('convert from json', () {
      final Message fromJsonTestMessage = Message(
        uid: 'testUid',
        text: 'testText',
        authorName: 'testAuthor',
        authorUid: 'testUserUid',
        timeStamp: Timestamp.fromMillisecondsSinceEpoch(1642398059739),
        isNew: true,
        isTest: false,
      );
      expect(Message.fromJson(testJson, 'testUid'), fromJsonTestMessage);
    });
    test('convert to json', () {
      final Message toJsonTestMessage = Message(
        text: 'testText',
        authorName: 'testAuthor',
        authorUid: 'testUserUid',
        timeStamp: Timestamp.fromMillisecondsSinceEpoch(1642398059739),
        isNew: true,
        isTest: true,
      );
      expect(toJsonTestMessage.toJson(), testJson);
    });
  });
}
