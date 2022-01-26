import 'package:flutter/material.dart';
import 'package:skelly/src/message/input_bubble.dart';
import 'package:skelly/src/message/thread_controller.dart';
import 'package:skelly/src/user/user_controller.dart';

import 'message.dart';
import 'message_bubble.dart';
import 'unsub_bubble.dart';

class MessageThread extends StatelessWidget {
  const MessageThread(
      {Key? key,
      required this.userController,
      required this.threadController,
      required this.threadIndex})
      : super(key: key);

  final ThreadController threadController;
  final int threadIndex;
  final UserController userController;

  @override
  Widget build(BuildContext context) {
    final Thread? thread;
    final bool isLast = threadIndex >= threadController.threads.length;

    if (!isLast) {
      thread = threadController.threads[threadIndex];
    } else {
      thread = null;
    }
    return isLast
        ? Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 5, 10),
                child: InputBubble(
                  threadController: threadController,
                  userController: userController,
                  threadIndex: threadIndex,
                ),
              ),
            ],
          )
        : SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                // TODO optimize building of large threads
                for (var message in thread!.messages.values)
                  MessageBubble(
                      message: message, userController: userController),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    UnsubBubble(
                        height: 30,
                        threadController: threadController,
                        thread: thread),
                    InputBubble(
                      userController: userController,
                      threadController: threadController,
                      threadIndex: threadIndex,
                    ),
                  ],
                ),
                // TODO find better way than reversing while widget list
              ].reversed.toList(),
            ));
  }
}
