import 'package:flutter/material.dart';
import 'package:skelly/src/message/message.dart';

import 'package:skelly/src/message/round_button.dart';
import 'package:skelly/src/message/thread_controller.dart';
import 'package:skelly/src/user/user_controller.dart';

enum BubbleState {
  textField,
  animatingToTextField,
  plusButton,
  animatingToPlusButton
}

class InputBubble extends StatefulWidget {
  const InputBubble(
      {Key? key,
      required this.userController,
      required this.threadController,
      required this.threadIndex})
      : super(key: key);

  final UserController userController;
  final ThreadController threadController;
  final int threadIndex;

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
  late bool isLastIndex;

  static const double _width = 30;

  @override
  void initState() {
    _bubbleState = BubbleState.plusButton;
    textController = TextEditingController();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // If the build index is greater than the number of threads then we're
    // drawing the "new thread" input bubble
    isLastIndex = widget.threadIndex >= widget.threadController.threads.length;

    return Column(
      children: [
        Row(
          children: [
            AnimatedContainer(
                onEnd: () {
                  setState(() {
                    if (_bubbleState == BubbleState.animatingToPlusButton) {
                      _bubbleState = BubbleState.plusButton;
                    } else if (_bubbleState ==
                        BubbleState.animatingToTextField) {
                      _bubbleState = BubbleState.textField;
                    }
                  });
                },
                clipBehavior: Clip.hardEdge,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
                margin: const EdgeInsets.fromLTRB(10, 2, 5, 2),
                padding: _isButtonState
                    ? const EdgeInsets.fromLTRB(2, 2, 2, 2)
                    : const EdgeInsets.fromLTRB(10, 10, 10, 10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(_width / 2),
                ),
                width: _isButtonState
                    ? _width
                    : MediaQuery.of(context).size.width - 150,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    RoundButton(
                        iconData: _isButtonState ? Icons.add : Icons.cancel,
                        height: 26,
                        width: 26,
                        onSubmit: () => setState(() {
                              if (_isTextState) {
                                textController.clear();
                                _bubbleState =
                                    BubbleState.animatingToPlusButton;
                              } else {
                                _bubbleState = BubbleState.animatingToTextField;
                              }
                            })),
                    Expanded(
                      child: _isTextState
                          ? TextField(
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
                      opacity:
                          _bubbleState == BubbleState.textField ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 200),
                      child: _bubbleState == BubbleState.textField
                          ? RoundButton(
                              iconData: Icons.arrow_upward,
                              height: 26,
                              width: 26,
                              onSubmit: () => setState(() {
                                    final Message message = Message(
                                        text: textController.text,
                                        author:
                                            widget.userController.displayName!,
                                        userUid: widget.userController.userUid!,
                                        isTest: false);
                                    if (isLastIndex) {
                                      widget.threadController
                                          .createThread(message);
                                    } else {
                                      final String threadUid = widget
                                          .threadController
                                          .threads[widget.threadIndex]
                                          .uid;

                                      widget.threadController
                                          .putToThread(threadUid, message);
                                    }
                                    textController.clear();
                                    _bubbleState =
                                        BubbleState.animatingToPlusButton;
                                  }))
                          : Container(),
                    ),
                  ],
                )),
          ],
        ),
        // Empty text container to match height to message bubble author label
        const Text(
          '',
          textAlign: TextAlign.end,
        ),
      ],
    );
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }
}
