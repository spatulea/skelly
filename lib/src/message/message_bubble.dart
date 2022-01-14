import 'package:flutter/material.dart';
import 'package:skelly/src/user/user_controller.dart';
import 'message.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    required this.message,
    required this.userController,
    Key? key,
  }) : super(key: key);

  final Message message;
  final UserController userController;

  @override
  Widget build(BuildContext context) {
    final bool isAuthor = message.userUid == (userController.userUid ?? '');
    return Container(
      padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
      width: flexWidth(message.text.length, message.author.length, context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(10, 7, 10, 7),
            decoration: BoxDecoration(
              color: isAuthor ? Colors.blue.shade300 : Colors.grey.shade400,
              borderRadius: BorderRadius.circular(13),
            ),
            child: message.text != ''
                ? Text(
                    message.text,
                  )
                : const Icon(
                    Icons.do_not_disturb,
                    color: Colors.grey,
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
double? flexWidth(int textLength, int authorLength, BuildContext context) {
  if (textLength > 100) return (MediaQuery.of(context).size.width - 100);
  if (textLength > 50) return 200;
  if (textLength > 20) return 150;
  return null;
}
