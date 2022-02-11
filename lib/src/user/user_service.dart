import 'package:cloud_firestore/cloud_firestore.dart';

import '../debug/debug.dart';
import 'generate_name.dart';

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
      await _usersCollection.doc(userUid).update({
        'lastUpdateTime': FieldValue.serverTimestamp(),
        'subscribedThreads': FieldValue.arrayUnion([]),
        'authoredThreads': FieldValue.arrayUnion([]),
        'blockedUsers': FieldValue.arrayUnion([]),
      });
    } on FirebaseException catch (e) {
      if (e.code == 'not-found') {
        debug(
            'User $userUid does not exist in collection, creating new user document',
            origin: origin);
        await _usersCollection.doc(userUid).set({
          'displayName': await GenerateName.name,
          'subscribedThreads': [],
          'authoredThreads': [],
          'blockedUsers': [],
          'lastUpdateTime': FieldValue.serverTimestamp(),
        }).onError((error, stackTrace) => debug(
            'Error $error unable to create user $userUid in users collection. Trace: $stackTrace',
            origin: origin));
      } else {
        debug(
            'Error $e while trying to locate user $userUid in users collection',
            origin: origin);
      }
    } catch (e) {
      debug('Error $e while trying to locate user $userUid in users collection',
          origin: origin);
    }
    _thisUserUid = userUid;
  }

  Stream<String?> get userDisplayName =>
      _usersCollection.doc(_thisUserUid).snapshots().map((documentSnapshot) {
        // displayName could be missing in the user document
        try {
          return documentSnapshot.get('displayName') as String?;
        } catch (e) {
          return 'Unnamed Hippo';
        }
      });

  Stream<Set<String>> get subscribedThreads =>
      _usersCollection.doc(_thisUserUid).snapshots().map((documentSnapshot) {
        // subscribedThreads could be missing in the user document
        try {
          return (documentSnapshot.get('subscribedThreads') as List<dynamic>)
              .cast<String>()
              .toSet();
        } catch (e) {
          return <String>{};
        }
      });

  Stream<Set<String>> get authoredThreads =>
      _usersCollection.doc(_thisUserUid).snapshots().map((documentSnapshot) {
        // authoredThreads could be missing in the user document
        try {
          return (documentSnapshot.get('authoredThreads') as List<dynamic>)
              .cast<String>()
              .toSet();
        } catch (e) {
          return <String>{};
        }
      });

  Stream<Set<String>> get blockedUsers =>
      _usersCollection.doc(_thisUserUid).snapshots().map((documentSnapshot) {
        // blockedUsers could be missing in the user document
        try {
          return (documentSnapshot.get('blockedUsers') as List<dynamic>)
              .cast<String>()
              .toSet();
        } catch (e) {
          return <String>{};
        }
      });

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

  Future<void> addAuthoredThread(String threadUid) async {
    _usersCollection.doc(_thisUserUid).update({
      'authoredThreads': FieldValue.arrayUnion([threadUid])
    });
  }

  Future<void> addBlockedUser(String userUid) async {
    _usersCollection.doc(_thisUserUid).update({
      'blockedUsers': FieldValue.arrayUnion([userUid])
    });
  }

  Future<void> removeBlockedUser(String userUid) async {
    _usersCollection.doc(_thisUserUid).update({
      'blockedUsers': FieldValue.arrayRemove([userUid])
    });
  }
}
