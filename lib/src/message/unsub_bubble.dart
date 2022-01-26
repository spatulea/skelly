import 'package:flutter/material.dart';

import 'message.dart';
import 'round_button.dart';
import 'thread_controller.dart';

enum ButtonState { single, toSingle, expanded, toExpanded }

class UnsubBubble extends StatefulWidget {
  const UnsubBubble({
    Key? key,
    required this.height,
    required this.threadController,
    required this.thread,
  }) : super(key: key);

  final ThreadController threadController;
  final Thread thread;
  final double height;

  @override
  State<UnsubBubble> createState() => _UnsubBubbleState();
}

class _UnsubBubbleState extends State<UnsubBubble> {
  late ButtonState _buttonState;
  bool get _singleish =>
      _buttonState == ButtonState.single ||
      _buttonState == ButtonState.toSingle;

  @override
  void initState() {
    _buttonState = ButtonState.single;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      width: _singleish ? widget.height : widget.height * 2 + 10,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(widget.height / 2),
      ),
      padding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
      margin: const EdgeInsets.fromLTRB(10, 2, 5, 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          RoundButton(
              width: widget.height - 4,
              height: widget.height - 4,
              iconData: _singleish ? Icons.remove : Icons.cancel,
              color: Colors.red.shade300,
              onSubmit: () {
                _singleish
                    ? setState(() => _buttonState = ButtonState.toExpanded)
                    : setState(() => _buttonState = ButtonState.toSingle);
              }
              // widget.threadController.unsubscribeThread(widget.thread),
              ),
          Expanded(child: Container()),
          AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            opacity: _buttonState == ButtonState.expanded ? 1.0 : 0,
            child: _buttonState == ButtonState.expanded
                ? RoundButton(
                    width: widget.height - 4,
                    height: widget.height - 4,
                    iconData: Icons.check,
                    color: Colors.red.shade300,
                    onSubmit: () => widget.threadController
                        .unsubscribeThread(widget.thread))
                : Container(),
          )
        ],
      ),
      onEnd: () {
        _singleish
            ? setState(() => _buttonState = ButtonState.single)
            : setState(() => _buttonState = ButtonState.expanded);
      },
    );
  }
}
