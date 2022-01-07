import 'package:flutter/material.dart';
import 'package:skelly/src/message/thread_controller.dart';

import '../settings/settings_view.dart';
import 'message_thread.dart';

/// Displays a list of SampleItems.
class ThreadListView extends StatelessWidget {
  ThreadListView({
    Key? key,
    required this.threadController,
  }) : super(key: key);

  final ThreadController threadController;

  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: threadController,
        builder: (context, _) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Message Threads'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () {
                    // Navigate to the settings page. If the user leaves and returns
                    // to the app after it has been killed while running in the
                    // background, the navigation stack is restored.
                    Navigator.restorablePushNamed(
                        context, SettingsView.routeName);
                  },
                ),
              ],
            ),
            body: Container(
              child: ListView.builder(
                // Providing a restorationId allows the ListView to restore the
                // scroll position when a user leaves and returns to the app after it
                // has been killed while running in the background.
                restorationId: 'threadListView',
                shrinkWrap: true,
                itemCount: threadController.threads.length,
                itemBuilder: (BuildContext context, int index) {
                  // return ListTile(
                  //     title: Text('SampleItem ${item.id}'),
                  //     leading: const CircleAvatar(
                  //       // Display the Flutter Logo image asset.
                  //       foregroundImage: AssetImage('assets/images/flutter_logo.png'),
                  //     ),
                  //     onTap: () {
                  //       // Navigate to the details page. If the user leaves and returns to
                  //       // the app after it has been killed while running in the
                  //       // background, the navigation stack is restored.
                  //       Navigator.restorablePushNamed(
                  //         context,
                  //         SampleItemDetailsView.routeName,
                  //       );
                  //     });
                  return MessageThread(thread: threadController.threads[index]);
                },
              ),
            ),
          );
        });
  }
}
