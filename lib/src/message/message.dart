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
  final String author;
  final String userUid;
  final Timestamp? timeStamp;
  bool? isNew;
  final bool isTest;

  Message(
      {this.uid,
      required this.text,
      required this.author,
      required this.userUid,
      this.timeStamp,
      this.isNew,
      this.isTest = false});

  Message.fromJson(Map<dynamic, dynamic> json, this.uid)
      : text = json['text'] as String,
        author = json['author'] as String,
        userUid = json['userUid'] as String,
        timeStamp = Timestamp.fromMillisecondsSinceEpoch(json['timeStamp']),
        isNew = true,
        isTest = false;

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        // 'uid': uid,
        'text': text,
        'author': author,
        'userUid': userUid,
        // if testing use given timestamp not remote
        'timeStamp':
            isTest ? (timeStamp ?? 1642398059739) : ServerValue.timestamp,
      };

  // Enable object comparison (ignoring isTest)
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Message &&
          uid == other.uid &&
          text == other.text &&
          author == other.author &&
          userUid == other.userUid &&
          timeStamp == other.timeStamp &&
          isNew == other.isNew;

  @override
  int get hashCode =>
      uid.hashCode ^
      text.hashCode ^
      author.hashCode ^
      userUid.hashCode ^
      timeStamp.hashCode ^
      isNew.hashCode;
}
