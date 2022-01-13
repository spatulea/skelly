import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:skelly/src/message/options_bubble.dart';
import 'package:skelly/src/message/round_button.dart';
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

    return GestureDetector(
      onTap: () {
        threadController.createThread(Message(
            uid: '',
            text: 'new thread!',
            author: 'itsa me!',
            userUid: 'itsameUid',
            timeStamp: Timestamp.now(),
            isNew: true,
            isTest: true));
      },
      child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              // TODO optimize building of large threads
              for (var message in thread.messages.values)
                MessageBubble(message: message),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(13),
                      ),
                      padding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
                      margin: const EdgeInsets.fromLTRB(10, 2, 5, 2),
                      child: RoundButton(
                        iconData: Icons.remove,
                        color: Colors.red,
                        onSubmit: () =>
                            threadController.unsubscribeThread(thread),
                      )),
                  OptionsBubble(
                    threadController: threadController,
                    threadIndex: threadIndex,
                  ),
                ],
              ),
            ].reversed.toList(),
          )),
    );
  }
}
