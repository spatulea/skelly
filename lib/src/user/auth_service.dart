import 'package:firebase_auth/firebase_auth.dart';

import '../debug/debug.dart';

class AuthService {
  static const String _className = 'AuthService';

  static late FirebaseAuth _auth;

  static late Stream<String?> _authUid;

  Stream<String?> get authUid => _authUid;

  Future<void> initialize() async {
    const String _origin = _className + '.initialize';

    _auth = FirebaseAuth.instance;

    // attach our _authUid stream to FirebaseAuth's authState stream
    // picking out the userUid for _authUid
    _authUid = _auth.authStateChanges().map((User? user) {
      if (user == null) {
        debug('User is not signed in', origin: _origin);
      } else {
        debug('User ${user.uid} signed in to auth', origin: _origin);
      }
      return user?.uid;
    });

    await _auth.signInAnonymously();
  }
}
