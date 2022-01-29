import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import 'message.dart';
import 'round_button.dart';

class ShareBubble extends StatelessWidget {
  const ShareBubble({
    Key? key,
    this.size = 26,
    this.iconSize = 18,
    this.margin = 2,
    required this.thread,
  }) : super(key: key);

  final Thread thread;
  final double size;
  final double iconSize;
  final double margin;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(margin),
        child: RoundButton(
          size: size,
          iconSize: iconSize,
          iconData: Icons.ios_share_rounded,
          onSubmit: () => Share.share(
              'Check out a new strfsh thread: strfshapp://strfsh.app/?threadUid=${thread.uid}'),
        ));
  }
}
