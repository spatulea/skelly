import 'package:flutter/material.dart';

import 'message.dart';
import 'message_bubble.dart';

class MessageThread extends StatelessWidget {
  MessageThread({Key? key, required this.thread}) : super(key: key);

  final Thread thread;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            // TODO optimize building of large threads
            for (var message in thread.messages.values)
              MessageBubble(message: message)
          ].reversed.toList(),
        ));
  }
}
