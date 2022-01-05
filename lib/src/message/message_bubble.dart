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
    return Container(
      padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
      width: flexWidth(message.text.length, message.author.length, context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(10, 7, 10, 7),
            decoration: BoxDecoration(
              color: Colors.amber,
              // color: author == fireState.myName
              //     ? MyColors.thisUserBubbleBackground
              //     : MyColors.otherUserBubbleBackground,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Text(
              message.text + message.text.length.toString(),
              // style: TextStyle(
              //     color: author == fireState.myName
              //         ? MyColors.thisUserBubbleForeground
              //         : MyColors.otherUserBubbleForeground),
            ),
          ),
          Text(
            message.author,
            textAlign: TextAlign.end,
            // style: author == fireState.myName
            //     ? Styles.thisAuthorName
            //     : Styles.otherAuthorName
          ),
        ],
      ),
    );
  }
}

// Some preset bubble widths based on message (and maybe author) string lenghts
double flexWidth(int textLength, int authorLength, BuildContext context) {
  if (textLength > 100) return MediaQuery.of(context).size.width - 100;
  if (textLength > 50) return 200;
  return 150.0;
}
