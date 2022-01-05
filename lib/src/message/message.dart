import 'package:cloud_firestore/cloud_firestore.dart'
    show Timestamp, FieldValue;

class Message {
  final String text;
  final String author;
  final String userUid;
  final Timestamp timeStamp;
  bool isNew;
  final bool isTest;

  Message(
      {required this.text,
      required this.author,
      required this.userUid,
      required this.timeStamp,
      required this.isNew,
      this.isTest = false});

  Message.fromJson(Map<dynamic, dynamic> json)
      : text = json['text'] as String,
        author = json['author'] as String,
        userUid = json['userUid'] as String,
        timeStamp = json['timeStamp'] as Timestamp,
        isNew = true,
        isTest = false;

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        'text': text,
        'author': author,
        'userUid': userUid,
        // if testing use given timestamp not remote
        'timeStamp': isTest ? timeStamp : FieldValue.serverTimestamp(),
      };

  // Enable object comparison (ignoring isTest)
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Message &&
          text == other.text &&
          author == other.author &&
          userUid == other.userUid &&
          timeStamp == other.timeStamp &&
          isNew == other.isNew;

  @override
  int get hashCode =>
      text.hashCode ^
      author.hashCode ^
      userUid.hashCode ^
      timeStamp.hashCode ^
      isNew.hashCode;
}
