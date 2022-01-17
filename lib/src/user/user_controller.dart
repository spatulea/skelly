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
    const String origin = _className + '.initialize';

    await _authService.initialize();

    Stream<String?> authUidBroadcast = _authService.authUid.asBroadcastStream();

    // wait for a uid to be available
    _userUid = await authUidBroadcast.firstWhere((authUid) => authUid != null);

    // attach a listener to update the app's userUid if the authUid
    // ever changes
    authUidBroadcast.listen((newUid) async {
      if (newUid != null && newUid != _userUid) {
        debug('Received new userUid $newUid', origin: origin);
        _userUid = newUid;
        notifyListeners();

        // Now we're ready to (re)initialize the UserService
        _userService.initialize(userUid: _userUid!);
      }
    });

    // and initialize the UserService
    await _userService.initialize(userUid: _userUid!);

    // And attach a listener to the user's displayName
    _userService.userDisplayName.listen((newName) {
      if (newName != null && newName != _displayName) {
        debug('Received new displayName $newName', origin: origin);
        _displayName = newName;
        notifyListeners();
      }
    });
  }
}
