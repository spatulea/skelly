import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../settings/settings_view.dart';
import 'sample_item.dart';
import 'sample_item_details_view.dart';
import '../message/message_bubble.dart';
import '../message/message.dart';
import '../message/message_thread.dart';

final List<Message> messageHorizontalList = [
  Message(
      text:
          'some first message text that is very long and may need multiple lines and may cause issues with overflow if not controlled to take up less space than this will accomodate this is strange',
      author: 'some first author',
      userUid: 'some uUid',
      timeStamp: Timestamp.now(),
      isNew: true),
  Message(
      text:
          'some second message text that is mid size in length so as to help me correctly size the bubble',
      author: 'some second author',
      userUid: 'some uUid',
      timeStamp: Timestamp.now(),
      isNew: true),
  Message(
      text: 'some third message text',
      author: 'some third author',
      userUid: 'some uUid',
      timeStamp: Timestamp.now(),
      isNew: true)
];

final List<List<Message>> messageVerticalList = [
  messageHorizontalList,
  messageHorizontalList.sublist(1),
  messageHorizontalList.sublist(2)
];

/// Displays a list of SampleItems.
class ThreadListView extends StatelessWidget {
  ThreadListView({
    Key? key,
  }) : super(key: key);

  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
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
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),

      // To work with lists that may contain a large number of items, it’s best
      // to use the ListView.builder constructor.
      //
      // In contrast to the default ListView constructor, which requires
      // building all Widgets up front, the ListView.builder constructor lazily
      // builds Widgets as they’re scrolled into view.
      body: Container(
        child: ListView.builder(
          // Providing a restorationId allows the ListView to restore the
          // scroll position when a user leaves and returns to the app after it
          // has been killed while running in the background.
          restorationId: 'threadListView',
          shrinkWrap: true,
          itemCount: messageVerticalList.length,
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
            return MessageThread(messageList: messageVerticalList[index]);
          },
        ),
      ),
    );
  }
}
