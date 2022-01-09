import 'package:flutter/material.dart';
import 'package:skelly/src/message/options_bubble.dart';
import 'package:skelly/src/message/thread_controller.dart';

import 'message.dart';
import 'message_bubble.dart';

class MessageThread extends StatelessWidget {
  MessageThread(
      {Key? key, required this.threadController, required this.threadIndex})
      : super(key: key);

  final ThreadController threadController;
  final int threadIndex;

  @override
  Widget build(BuildContext context) {
    final Thread thread = threadController.threads[threadIndex];

    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            // TODO optimize building of large threads
            for (var message in thread.messages.values)
              MessageBubble(message: message),
            OptionsBubble(
              threadController: threadController,
              threadIndex: threadIndex,
            ),
          ].reversed.toList(),
        ));
  }
}
