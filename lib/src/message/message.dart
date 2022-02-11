import 'package:cloud_firestore/cloud_firestore.dart' show Timestamp;
import 'package:firebase_database/firebase_database.dart' show ServerValue;

class Thread {
  Thread(this.messages, {required this.uid});
  final String uid;
  final Map<String, Message> messages;
}

class Message {
  final String? uid;
  final String text;
  final String authorName;
  final String authorUid;
  final Timestamp? timeStamp;
  bool? isNew;
  final bool isTest;

  Message(
      {this.uid,
      required this.text,
      required this.authorName,
      required this.authorUid,
      this.timeStamp,
      this.isNew,
      this.isTest = false});

  Message.fromJson(Map<dynamic, dynamic> json, this.uid)
      : text = json['text'] as String,
        authorName = json['authorName'] as String,
        authorUid = json['authorUid'] as String,
        timeStamp =
            Timestamp.fromMillisecondsSinceEpoch(json['timeStamp'] as int),
        isNew = true,
        isTest = false;

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        // 'uid': uid,
        'text': text,
        'authorName': authorName,
        'authorUid': authorUid,
        // if testing use given timestamp not remote
        'timeStamp': isTest
            ? (timeStamp?.millisecondsSinceEpoch ?? 1642398059739)
            : ServerValue.timestamp,
      };

  // Enable object comparison (ignoring isTest)
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Message &&
          uid == other.uid &&
          text == other.text &&
          authorName == other.authorName &&
          authorUid == other.authorUid &&
          timeStamp == other.timeStamp &&
          isNew == other.isNew;

  @override
  int get hashCode =>
      uid.hashCode ^
      text.hashCode ^
      authorName.hashCode ^
      authorUid.hashCode ^
      timeStamp.hashCode ^
      isNew.hashCode;
}
