import 'package:flutter/material.dart';

import '../user/user_controller.dart';
import 'thread_controller.dart';
import 'message.dart';
import 'message_bubble.dart';
import 'thread_buttons.dart';

class MessageThread extends StatefulWidget {
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
  State<MessageThread> createState() => _MessageThreadState();
}

class _MessageThreadState extends State<MessageThread> {
  double _opacity = 0.0;

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) => setState(() {
          _opacity = 1.0;
        }));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Thread thread = widget.threadController.threads[widget.threadIndex];

    return AnimatedOpacity(
      opacity: _opacity,
      duration: const Duration(milliseconds: 200),
      child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              // TODO optimize building of large threads

              // for each message in a thread where the author's userUid is not
              // in this user's blockedUsers list
              for (var message in thread.messages.values.where((message) =>
                  !widget.userController.blockedUsers
                      .contains(message.authorUid)))
                MessageBubble(
                    message: message, userController: widget.userController),
              ThreadButtons(
                  threadController: widget.threadController,
                  thread: thread,
                  userController: widget.userController,
                  threadIndex: widget.threadIndex),
              // TODO find better way than reversing whole widget list
            ].reversed.toList(),
          )),
    );
  }
}
