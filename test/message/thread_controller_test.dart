import 'package:flutter_test/flutter_test.dart';
import 'package:skelly/src/message/thread_controller.dart';

import '../mock_auth_service.dart';
import '../mock_thread_service.dart';
import '../mock_user_service.dart';

void main() {
  final authService = MockAuthService();
  final userService = MockUserService();
  final threadService = MockThreadService();

  final threadController = ThreadController(userService, threadService);
  group('ThreadController.subscribeThreads should', () {
    test('inform the service of the value', () async {});
  });
}
