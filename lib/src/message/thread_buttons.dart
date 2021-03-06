import 'package:flutter/material.dart';

import '../message/thread_controller.dart';
import '../user/user_controller.dart';
import 'input_bubble.dart';
import 'message.dart';
import 'share_bubble.dart';
import 'unsub_bubble.dart';

class ThreadButtons extends StatelessWidget {
  const ThreadButtons({
    Key? key,
    required this.threadController,
    required this.thread,
    required this.userController,
    required this.threadIndex,
  }) : super(key: key);

  final ThreadController threadController;
  final Thread thread;
  final UserController userController;
  final int threadIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 5, 5, 20),
      child: Row(
        children: [
          Stack(
            alignment: AlignmentDirectional.bottomStart,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ShareBubble(
                    thread: thread,
                  ),
                  UnsubBubble(
                    size: 26,
                    threadController: threadController,
                    thread: thread,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  UnsubBubble(
                    size: 26,
                    threadController: threadController,
                    thread: thread,
                  ),
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              InputBubble(
                userController: userController,
                threadController: threadController,
                thread: thread,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
