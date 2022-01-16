import 'package:flutter_test/flutter_test.dart';
import 'package:skelly/src/message/thread_controller.dart';
import 'package:skelly/src/user/user_controller.dart';

import '../mock_auth_service.dart';
import '../mock_user_service.dart';

void main() {
  final authService = MockAuthService();
  final userService = MockUserService();

  final userController = UserController(userService, authService);
  group('UserController should', () {
    test('initialize AuthService', () async {
      await userController.initialize();
      // TODO maybe we can do better than using timed delays
      await Future.delayed(const Duration(milliseconds: 500));
      expect(userController.userUid, 'firstUserUid');
    });

    test('handle new uid from AuthService', () async {
      // TODO maybe we can do better than using timed delays
      await Future.delayed(const Duration(seconds: 1));
      expect(userController.userUid, 'mockUserUid');
    });

    test('initialize UserService', () async {
      expect(userController.displayName, 'mockUserName');
    });
  });
}
