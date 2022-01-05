import 'package:flutter_test/flutter_test.dart';
import 'package:skelly/src/message/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart' show Timestamp;

void main() {
  final Map<dynamic, dynamic> testJson = {
    'text': 'testText',
    'author': 'testAuthor',
    'userUid': 'testUserUid',
    'timeStamp': Timestamp.fromMicrosecondsSinceEpoch(1641358386000000),
  };
  group('Message should', () {
    // test('create from constructor', () {});
    test('convert from json', () {
      final Message fromJsonTestMessage = Message(
        text: 'testText',
        author: 'testAuthor',
        userUid: 'testUserUid',
        timeStamp: Timestamp.fromMicrosecondsSinceEpoch(1641358386000000),
        isNew: true,
        isTest: false,
      );
      expect(Message.fromJson(testJson), fromJsonTestMessage);
    });
    test('convert to json', () {
      final Message toJsonTestMessage = Message(
        text: 'testText',
        author: 'testAuthor',
        userUid: 'testUserUid',
        timeStamp: Timestamp.fromMicrosecondsSinceEpoch(1641358386000000),
        isNew: true,
        isTest: true,
      );
      expect(toJsonTestMessage.toJson(), testJson);
    });
  });
}
