import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:skelly/src/message/send_button.dart';
import 'package:skelly/src/message/thread_controller.dart';

class OptionsBubble extends StatefulWidget {
  const OptionsBubble(
      {Key? key, required this.threadController, required this.threadIndex})
      : super(key: key);

  final ThreadController threadController;
  final int threadIndex;

  @override
  State<OptionsBubble> createState() => _OptionsBubbleState();
}

class _OptionsBubbleState extends State<OptionsBubble> {
  late bool buttonMode;

  @override
  void initState() {
    buttonMode = true;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            AnimatedContainer(
                duration: const Duration(seconds: 2),
                curve: Curves.fastLinearToSlowEaseIn,
                margin: const EdgeInsets.fromLTRB(10, 2, 5, 2),
                padding: buttonMode
                    ? const EdgeInsets.fromLTRB(2, 2, 2, 2)
                    : const EdgeInsets.fromLTRB(10, 10, 10, 10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(13),
                ),
                width:
                    buttonMode ? 30 : MediaQuery.of(context).size.width - 150,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: buttonMode
                          ? Container()
                          : const TextField(
                              textAlignVertical: TextAlignVertical.bottom,
                              decoration: InputDecoration(
                                  counterText: '',
                                  contentPadding: EdgeInsets.all(2),
                                  border: InputBorder.none,
                                  isDense: true),
                              minLines: 1,
                              maxLines: 8,
                              maxLength: 200,
                              autofocus: true,
                            ),
                    ),
                    SendButton(
                        height: 26,
                        width: 26,
                        onSubmit: () => setState(() {
                              buttonMode = !buttonMode;
                            })),
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
    // TODO: implement dispose
    super.dispose();
  }
}



                  // ? IconButton(
                  //     iconSize: 30,
                  //     icon: const Icon(Icons.add),
                  //     onPressed: () {
                  //       setState(() {
                  //         buttonMode = false;
                  //       });
                  //     },
                  //   )