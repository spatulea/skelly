import 'package:flutter/material.dart';
import 'package:skelly/src/debug/debug.dart';
import 'package:skelly/src/user/user_controller.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

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
      margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
      padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
      width: flexWidth(message.text.length, message.author.length, context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(10, 7, 10, 7),
            decoration: BoxDecoration(
              color: isAuthor
                  ? Theme.of(context).colorScheme.primaryVariant
                  : Theme.of(context).colorScheme.secondaryVariant,
              borderRadius: BorderRadius.circular(13),
            ),
            child: message.text != ''
                ? Linkify(
                    text: message.text,
                    onOpen: (link) async {
                      if (!await launch(link.url)) {
                        debug('Could not launch ${link.url}');
                      }
                    },
                  )
                : const Icon(
                    Icons.do_not_disturb,
                    color: Colors.grey,
                  ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                message.author,
                textAlign: TextAlign.end,
              ),
              const SizedBox(width: 2),
              GestureDetector(
                onTap: () => userController.blockUser(message.userUid),
                child: Icon(
                  Icons.error_outline,
                  size: 16,
                  color: Theme.of(context).colorScheme.error,
                ),
              )
            ],
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
