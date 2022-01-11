import 'dart:math';

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

abstract class UserService {
  static late Stream<String> _userDisplayName;
  static late Stream<Set<String>> _subscribedThreads;
  static late Stream<Set<String>> _authoredThreads;

  static Stream<String> get userDisplayName => _userDisplayName;
  static Stream<Set<String>> get subscribedThreads => _subscribedThreads;
  static Stream<Set<String>> get authoredThreads => _authoredThreads;

  static late String _thisUserUid;

  static void initialize({required String userUid}) {
    // Make sure the user's uid is in the collection
    if (!_mockUsersCollection.containsKey(userUid)) {
      throw Error();
    }

    _thisUserUid = userUid;

    // Mock an infinite stream of user's display name, only yielding on changes
    _userDisplayName = () async* {
      String _cached = '';
      while (true) {
        await Future<void>.delayed(
            Duration(milliseconds: Random().nextInt(100)));
        var _new = _mockUsersCollection[userUid]!['displayName'] as String;
        if (_new != _cached) {
          _cached = _new;
          yield _new;
        }
      }
    }();

    // Mock an infinite stream of subscribed threads, only yielding on changes
    _subscribedThreads = () async* {
      Set<String> _cached = {};
      while (true) {
        await Future<void>.delayed(
            Duration(milliseconds: Random().nextInt(100)));
        var _new =
            _mockUsersCollection[userUid]!['subscribedThreads'] as Set<String>;
        if (_new != _cached) {
          _cached = _new;
          yield _new;
        }
      }
    }();

    // Mock an infinite stream of authored threads, only yielding on changes
    _authoredThreads = () async* {
      while (true) {
        Set<String> _cached = {};
        await Future<void>.delayed(
            Duration(milliseconds: Random().nextInt(100)));
        var _new =
            _mockUsersCollection[userUid]!['authoredThreads'] as Set<String>;
        if (_new != _cached) {
          _cached = _new;
          yield _new;
        }
      }
    }();
  }

  Future<void> subscribeToThread(String threadUid) async {
    // TODO add check that thread exists (convert ThreadService to abstract?)

    _mockUsersCollection[_thisUserUid]!['subscribedThreads'].add(threadUid);
  }
}
