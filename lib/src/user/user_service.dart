import 'dart:math';

import 'package:skelly/src/debug/debug.dart';

Map<String, Map<String, dynamic>> _mockUsersCollection = {
  'userUid1': {
    'displayName': 'someName',
    'subscribedThreads': {'threadId1', 'threadId2'},
    'authoredThreads': {'threadId2'},
  },
  'userUid2': {
    'displayName': 'someOtherName',
    'subscribedThreads': {'threadId2'},
    'authoredThreads': {},
  }
};

class UserService {
  static const _className = 'UserService';

  Stream<String?> get userDisplayName => _userDisplayName();
  Stream<Set<String>> get subscribedThreads => _subscribedThreads();
  Stream<Set<String>> get authoredThreads => _authoredThreads();

  static late String _thisUserUid;

  Future<void> initialize({required String userUid}) async {
    const String _origin = _className + '.initialize';

    // Make sure the user's uid is in the collection, or create a new one!
    _mockUsersCollection.putIfAbsent(userUid, () {
      debug('Adding user $userUid to users collection', origin: _origin);

      return <String, dynamic>{
        'displayName': userUid,
        'subscribedThreads': {'threadId1'},
        'authoredThreads': {'threadId1'},
      };
    });

    _thisUserUid = userUid;
  }

  // Mock an infinite stream of user's display name, only yielding on changes
  static Stream<String?> _userDisplayName() async* {
    String _cached = '';
    while (true) {
      await Future<void>.delayed(Duration(milliseconds: Random().nextInt(100)));
      var _new = _mockUsersCollection[_thisUserUid]!['displayName'] as String;
      if (_new != _cached) {
        _cached = _new;
        yield _new;
      }
    }
  }

  // Mock an infinite stream of subscribed threads, only yielding on changes
  static Stream<Set<String>> _subscribedThreads() async* {
    Set<String> _cached = {};
    while (true) {
      await Future<void>.delayed(Duration(milliseconds: Random().nextInt(100)));
      var _new = _mockUsersCollection[_thisUserUid]!['subscribedThreads']
          as Set<String>;
      if (_new.difference(_cached).isNotEmpty ||
          _cached.difference(_new).isNotEmpty) {
        debug('Yielding new subscribedThread set $_new',
            origin: _className + '._subscribedThreads.stream');
        _cached = Set<String>.from(_new);
        yield _new;
      }
    }
  }

  // Mock an infinite stream of authored threads, only yielding on changes
  static Stream<Set<String>> _authoredThreads() async* {
    while (true) {
      Set<String> _cached = {};
      await Future<void>.delayed(Duration(milliseconds: Random().nextInt(100)));
      var _new =
          _mockUsersCollection[_thisUserUid]!['authoredThreads'] as Set<String>;
      if (_new.difference(_cached).isNotEmpty ||
          _cached.difference(_new).isNotEmpty) {
        debug('Yielding new authoredThread set $_new',
            origin: _className + '._subscribedThreads.stream');
        _cached = Set<String>.from(_new);
        yield _new;
      }
    }
  }

  Future<void> subscribeToThread(String threadUid) async {
    var subscribedThreads =
        _mockUsersCollection[_thisUserUid]!['subscribedThreads'] as Set<String>;

    subscribedThreads.add(threadUid);
  }

  Future<void> unsubscribeFromThread(String threadUid) async {
    var subscribedThreads =
        _mockUsersCollection[_thisUserUid]!['subscribedThreads'] as Set<String>;

    subscribedThreads.remove(threadUid);
  }
}
