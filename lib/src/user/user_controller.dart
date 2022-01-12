import 'package:flutter/material.dart';

import '../debug/debug.dart';
import 'user_service.dart';
import 'auth_service.dart';

class UserController with ChangeNotifier {
  static const String _className = 'UserController';
  final UserService _userService;
  final AuthService _authService;

  static String? _userUid;
  String? get userUid => _userUid;

  static String? _displayName;
  String? get displayName => _displayName;

  UserController(this._userService, this._authService);

  Future<void> initialize() async {
    await _authService.initialize();
    const String _origin = _className + '.initialize';

    // wait for a uid to be available
    _userUid =
        await _authService.authUid.firstWhere((authUid) => authUid != null);
    // and initialize the UserService
    await _userService.initialize(userUid: _userUid!);
    // And attach a listener to the user's displayName
    _userService.userDisplayName.listen((newName) {
      if (newName != null) {
        _displayName = newName;
        notifyListeners();
      }
    });

    // also attach a listener to update the app's userUid if the authUid
    // ever changes
    _authService.authUid.listen((newUid) async {
      debug('Received new userUid $newUid', origin: _origin);
      if (newUid != null) {
        _userUid = newUid;
        notifyListeners();

        // Now we're ready to (re)initialize the UserService
        await _userService.initialize(userUid: _userUid!);
      }
    });
  }
}
