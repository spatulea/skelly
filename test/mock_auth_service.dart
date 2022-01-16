import 'package:skelly/src/user/auth_service.dart';

class MockAuthService implements AuthService {
  Stream<String?> _mockFirebaseAuthStream() async* {
    List<String?> mockUids = [null, 'firstUserUid'];

    for (String? uid in mockUids) {
      await Future<void>.delayed(const Duration(milliseconds: 1));
      yield uid;
    }
    await Future.delayed(const Duration(milliseconds: 500));
    yield 'mockUserUid';
  }

  static late Stream<String?> _authUid;

  @override
  Stream<String?> get authUid => _authUid;

  @override
  Future<void> initialize() async {
    // attach our _authUid stream to mock FirebaseAuth's uid stream
    _authUid = _mockFirebaseAuthStream().map((String? userUid) {
      return userUid;
    });
  }
}
