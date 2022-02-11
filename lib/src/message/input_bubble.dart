import 'package:flutter/material.dart';

import 'message.dart';
import 'round_button.dart';
import 'thread_controller.dart';
import '../user/user_controller.dart';

enum BubbleState {
  textField,
  animatingToTextField,
  plusButton,
  animatingToPlusButton
}

class InputBubble extends StatefulWidget {
  const InputBubble(
      {Key? key,
      this.buttonSize = 26,
      this.margin = 2,
      required this.userController,
      required this.threadController,
      this.thread})
      : super(key: key);

  final UserController userController;
  final ThreadController threadController;
  final Thread? thread;
  final double buttonSize;
  final double margin;

  @override
  State<InputBubble> createState() => _InputBubbleState();
}

class _InputBubbleState extends State<InputBubble> {
  late BubbleState _bubbleState;
  bool get _isButtonState =>
      _bubbleState == BubbleState.plusButton ||
      _bubbleState == BubbleState.animatingToPlusButton;
  bool get _isTextState =>
      _bubbleState == BubbleState.textField ||
      _bubbleState == BubbleState.animatingToTextField;
  late final TextEditingController textController;

  @override
  void initState() {
    _bubbleState = BubbleState.plusButton;
    textController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        margin: EdgeInsets.all(widget.margin),
        onEnd: () {
          setState(() {
            if (_bubbleState == BubbleState.animatingToPlusButton) {
              _bubbleState = BubbleState.plusButton;
            } else if (_bubbleState == BubbleState.animatingToTextField) {
              _bubbleState = BubbleState.textField;
            }
          });
        },
        clipBehavior: Clip.hardEdge,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: _isButtonState
            ? const EdgeInsets.all(0)
            : const EdgeInsets.fromLTRB(10, 10, 10, 10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(widget.buttonSize / 2),
        ),
        width: _isButtonState
            ? widget.buttonSize
            : (MediaQuery.of(context).size.width - 150).clamp(100, 400),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            RoundButton(
                color: _isButtonState
                    ? null
                    : Theme.of(context).colorScheme.secondaryVariant,
                iconData:
                    _isButtonState ? Icons.add_rounded : Icons.close_rounded,
                size: 26,
                onSubmit: () => setState(() {
                      if (_isTextState) {
                        textController.clear();
                        _bubbleState = BubbleState.animatingToPlusButton;
                      } else {
                        _bubbleState = BubbleState.animatingToTextField;
                      }
                    })),
            Expanded(
              child: _isTextState
                  ? TextField(
                      cursorColor: Theme.of(context).textTheme.bodyText1!.color,
                      controller: textController,
                      textAlignVertical: TextAlignVertical.bottom,
                      decoration: const InputDecoration(
                          counterText: '',
                          contentPadding: EdgeInsets.all(4),
                          border: InputBorder.none,
                          isDense: true),
                      minLines: 1,
                      maxLines: 8,
                      maxLength: 200,
                      autofocus: true,
                    )
                  : Container(),
            ),
            AnimatedOpacity(
              curve: Curves.easeInOut,
              opacity: _bubbleState == BubbleState.textField ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: _bubbleState == BubbleState.textField
                  ? RoundButton(
                      iconData: Icons.arrow_upward,
                      size: 26,
                      onSubmit: () => setState(() {
                            final Message message = Message(
                                text: textController.text,
                                authorName: widget.userController.displayName!,
                                authorUid: widget.userController.userUid!,
                                isTest: false);
                            widget.thread == null
                                ? widget.threadController.createThread(message)
                                : widget.threadController
                                    .putToThread(widget.thread!.uid, message);

                            textController.clear();
                            _bubbleState = BubbleState.animatingToPlusButton;
                          }))
                  : Container(),
            ),
          ],
        ));
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }
}
