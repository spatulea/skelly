import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:skelly/src/debug/debug.dart';
import 'package:url_launcher/url_launcher.dart';

import 'settings_controller.dart';

/// Displays the various settings that can be customized by the user.
///
/// When a user changes a setting, the SettingsController is updated and
/// Widgets that listen to the SettingsController are rebuilt.
class SettingsView extends StatelessWidget {
  static const _className = 'SettingsView';
  const SettingsView({Key? key, required this.controller}) : super(key: key);

  static const routeName = '/settings';

  final SettingsController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        // Glue the SettingsController to the theme selection DropdownButton.
        //
        // When a user selects a theme from the dropdown list, the
        // SettingsController is updated, which rebuilds the MaterialApp.
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TODO implement light theme and re-enable
            // DropdownButton<ThemeMode>(
            //   // Read the selected themeMode from the controller
            //   value: controller.themeMode,
            //   // Call the updateThemeMode method any time the user selects a theme.
            //   onChanged: controller.updateThemeMode,
            //   items: const [
            //     DropdownMenuItem(
            //       value: ThemeMode.system,
            //       child: Text('System Theme'),
            //     ),
            //     DropdownMenuItem(
            //       value: ThemeMode.light,
            //       child: Text('Light Theme'),
            //     ),
            //     DropdownMenuItem(
            //       value: ThemeMode.dark,
            //       child: Text('Dark Theme'),
            //     )
            //   ],
            // ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: Text(
                '\u00a9 2022 Sebastian Patulea\n strfsh version ${controller.version}',
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(color: Theme.of(context).colorScheme.secondary),
                textAlign: TextAlign.center,
              ),
            ),
            Center(
              child: RichText(
                text: TextSpan(children: [
                  TextSpan(
                    text: 'You can find the ',
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                  TextSpan(
                      text: 'Source Code',
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          decoration: TextDecoration.underline),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          const link = 'https://github.com/spatulea/skelly';
                          if (await canLaunch(link)) {
                            await launch(link).onError((error, stackTrace) {
                              debug('Error $error stackTrace $stackTrace');
                              return false;
                            });
                          } else {
                            debug('Could not launch $link',
                                origin: _className + '.build.Linkify.opOpen');
                          }
                        }),
                  TextSpan(
                    text: '\nand ',
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                  TextSpan(
                      text: 'Privacy Policy',
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          decoration: TextDecoration.underline),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          const link =
                              'https://github.com/spatulea/skelly/blob/main/PRIVACY_POLICY.md';
                          if (await canLaunch(link)) {
                            await launch(link).onError((error, stackTrace) {
                              debug('Error $error stackTrace $stackTrace');
                              return false;
                            });
                          } else {
                            debug('Could not launch $link',
                                origin: _className + '.build.Linkify.onOpen');
                          }
                        }),
                  TextSpan(
                    text: ' on GitHub.',
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
