import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'message.dart';
import '../debug/debug.dart';
import '../user/user_controller.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    required this.message,
    required this.userController,
    Key? key,
  }) : super(key: key);

  final Message message;
  final UserController userController;
  static const String _className = 'MessageBubble';

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
                      try {
                        var tmp = await launch(link.url);
                      } catch (error) {
                        debug('Could not launch ${link.url} error $error',
                            origin: _className + '.build.Linkify.launch');
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
                style: TextStyle(color: Colors.grey.shade400),
                textAlign: TextAlign.end,
              ),
              if (!isAuthor) const SizedBox(width: 2),
              if (!isAuthor)
                GestureDetector(
                  child: Icon(
                    Icons.error_outline,
                    size: 16,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  onTap: () {
                    showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => CupertinoAlertDialog(
                              title: Text(AppLocalizations.of(context)!
                                  .blockDialogTitle),
                              content: Text(AppLocalizations.of(context)!
                                      .blockDialogBodyPre +
                                  '${message.author}?\n' +
                                  AppLocalizations.of(context)!
                                      .blockDialogBodyPost),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, 'Cancel'),
                                  child: const Icon(Icons.arrow_back_rounded),
                                ),
                                TextButton(
                                  onPressed: () {
                                    userController.blockUser(message.userUid);
                                    Navigator.pop(context, 'OK');
                                  },
                                  child: const Icon(Icons.check),
                                ),
                              ],
                            ));
                  },
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
