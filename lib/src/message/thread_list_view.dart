import 'package:flutter/material.dart';

import '../message/thread_controller.dart';
import '../user/user_controller.dart';
import 'input_bubble.dart';
import 'message_thread.dart';

/// Displays a list of SampleItems.
class ThreadListView extends StatelessWidget {
  const ThreadListView({
    Key? key,
    required this.threadController,
    required this.userController,
  }) : super(key: key);

  final ThreadController threadController;
  final UserController userController;

  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: threadController,
        builder: (context, _) {
          return Scaffold(
            body: CustomScrollView(
                // Providing a restorationId allows the ListView to restore the
                // scroll position when a user leaves and returns to the app after it
                // has been killed while running in the background.
                restorationId: 'threadListView',
                shrinkWrap: false,
                slivers: <Widget>[
                  SliverAppBar(
                    pinned: true,
                    // backgroundColor: Theme.of(context).backgroundColor,
                    toolbarHeight: 0.0,
                    collapsedHeight: 30.0,
                    expandedHeight: 40.0,
                    flexibleSpace: FlexibleSpaceBar(
                      title: Text(
                        userController.displayName ?? '',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      titlePadding: const EdgeInsets.all(4),
                    ),
                  ),
                  SliverList(
                      delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return index < threadController.threads.length
                          // Build regular thread
                          ? SafeArea(
                              top: false,
                              bottom: false,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                child: MessageThread(
                                  userController: userController,
                                  threadController: threadController,
                                  threadIndex: index,
                                ),
                              ),
                            )
                          // Or show the input bubble to create a new thread
                          : SafeArea(
                              top: false,
                              bottom: false,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: InputBubble(
                                      threadController: threadController,
                                      userController: userController,
                                    ),
                                  ),
                                ],
                              ),
                            );
                    },
                    childCount: threadController.threads.length + 1,
                  ))
                ]),
          );
        });
  }
}
