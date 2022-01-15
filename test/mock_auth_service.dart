import 'package:skelly/src/user/auth_service.dart';

class MockAuthService with AuthService {
  Stream<String?> _mockFirebaseAuthStream() async* {
    List<String?> mockUids = [null, 'someAuthUid'];

    for (String? uid in mockUids) {
      await Future<void>.delayed(const Duration(milliseconds: 10));
      yield uid;
    }
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
