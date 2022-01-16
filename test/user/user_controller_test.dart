import 'package:flutter_test/flutter_test.dart';
import 'package:skelly/src/message/thread_controller.dart';
import 'package:skelly/src/user/user_controller.dart';

import '../mock_auth_service.dart';
import '../mock_user_service.dart';

void main() {
  final authService = MockAuthService();
  final userService = MockUserService();

  final userController = UserController(userService, authService);
  group('UserController.initialize should', () {
    test('initializes AuthService', () async {
      userController.initialize();
      // wait for the mock stream to complete
      await Future.delayed(Duration(milliseconds: 10));

      expect(userController.userUid, 'userUid1');
    });
  });
}
