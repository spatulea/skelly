import 'package:flutter/material.dart';
import 'message.dart';
import 'message_bubble.dart';

class MessageThread extends StatelessWidget {
  MessageThread({Key? key, required this.thread}) : super(key: key);

  final Thread thread;

  @override
  Widget build(BuildContext context) {
    // return SizedBox(
    //   height: 200,
    //   child: ListView.builder(
    //     shrinkWrap: true,
    //     scrollDirection: Axis.horizontal,
    //     itemCount: messageList.length,
    //     itemBuilder: (BuildContext context, int index) {
    //       return Container(
    //           color: Colors.grey,
    //           child: MessageBubble(message: messageList[index]));
    //     },
    //   ),
    // );
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal, child: _buildThread(thread));
  }
}

// Build all messages in a single thread
// TODO performance will be an issue with large/long threads
Widget _buildThread(Thread thread) {
  List<Widget> bubbles = [];

  if (thread.messages.isEmpty) return Container();

  for (var message in thread.messages) {
    bubbles.add(MessageBubble(message: message));
  }
  return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: bubbles.reversed.toList());
}
