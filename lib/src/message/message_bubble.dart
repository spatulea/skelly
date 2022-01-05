import 'package:flutter/material.dart';
import 'message.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    required this.message,
    Key? key,
  }) : super(key: key);

  final Message message;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
                width: flexWidth(message.text.length > message.author.length
                    ? message.text.length
                    : message.author.length)),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 7, 10, 7),
                    // width: 60,
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      // color: author == fireState.myName
                      //     ? MyColors.thisUserBubbleBackground
                      //     : MyColors.otherUserBubbleBackground,
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Text(
                      message.text,
                      // style: TextStyle(
                      //     color: author == fireState.myName
                      //         ? MyColors.thisUserBubbleForeground
                      //         : MyColors.otherUserBubbleForeground),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        message.author,
                        // style: author == fireState.myName
                        //     ? Styles.thisAuthorName
                        //     : Styles.otherAuthorName
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(width: 20)
          ],
        ),
        Container(height: 10),
      ],
    );
  }
}

double flexWidth(int textLength) {
  if (textLength < 20) return 140;
  if (textLength < 140) return (140.0 - 1 * textLength);
  return 20;
}
