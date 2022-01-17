import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:skelly/src/debug/debug.dart';

class UserService {
  static const _className = 'UserService';

  static late String _thisUserUid;

  static late FirebaseFirestore _firestore;
  static late CollectionReference _usersCollection;

  String get currentUserUid => _thisUserUid;

  Future<void> initialize({required String userUid}) async {
    const String origin = _className + '.subscribe';

    _firestore = FirebaseFirestore.instance;
    _usersCollection = _firestore.collection('users');

    // Try to update the user document if it exists, create a new one if it
    // does not.
    try {
      await _usersCollection
          .doc(userUid)
          .update({'lastUpdateTime': FieldValue.serverTimestamp()});
    } catch (e) {
      debug(
          'User $userUid does not exist in collection, creating new user document',
          origin: origin);
      await _usersCollection.doc(userUid).set({
        'displayName': 'Mario',
        'subscribedThreads': ['threadUid1'],
        'authoredThreads': [],
        'lastUpdateTime': FieldValue.serverTimestamp(),
      }).onError((error, stackTrace) => debug(
          'Error $error unable to create user $userUid in users collection. Trace: $stackTrace',
          origin: origin));
    }
    _thisUserUid = userUid;
  }

  Stream<String?> get userDisplayName =>
      _usersCollection.doc(_thisUserUid).snapshots().map(
          (documentSnapshot) => documentSnapshot.get('displayName') as String?);

  Stream<Set<String>> get subscribedThreads =>
      _usersCollection.doc(_thisUserUid).snapshots().map((documentSnapshot) =>
          (documentSnapshot.get('subscribedThreads') as List<dynamic>)
              .cast<String>()
              .toSet());

  Stream<Set<String>> get authoredThreads =>
      _usersCollection.doc(_thisUserUid).snapshots().map((documentSnapshot) =>
          (documentSnapshot.get('authoredThreads') as List<dynamic>)
              .cast<String>()
              .toSet());

  Future<void> subscribeToThread(String threadUid) async {
    _usersCollection.doc(_thisUserUid).update({
      'subscribedThreads': FieldValue.arrayUnion([threadUid])
    });
  }

  Future<void> unsubscribeFromThread(String threadUid) async {
    _usersCollection.doc(_thisUserUid).update({
      'subscribedThreads': FieldValue.arrayRemove([threadUid])
    });
  }
}
