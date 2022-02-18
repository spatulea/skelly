import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'message/thread_controller.dart';
import 'user/user_controller.dart';
import 'message/thread_list_view.dart';
import 'settings/settings_controller.dart';
import 'settings/settings_view.dart';

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  const MyApp(
      {Key? key,
      required this.settingsController,
      required this.threadController,
      required this.userController})
      : super(key: key);

  final SettingsController settingsController;
  final ThreadController threadController;
  final UserController userController;

  @override
  Widget build(BuildContext context) {
    // Glue the SettingsController to the MaterialApp.
    //
    // The AnimatedBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.
    return AnimatedBuilder(
      animation: settingsController,
      builder: (BuildContext context, Widget? child) {
        // top-level onTap to hide keyboard when the user taps away
        return GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,

            // Providing a restorationScopeId allows the Navigator built by the
            // MaterialApp to restore the navigation stack when a user leaves and
            // returns to the app after it has been killed while running in the
            // background.
            restorationScopeId: 'app',

            // Provide the generated AppLocalizations to the MaterialApp. This
            // allows descendant Widgets to display the correct translations
            // depending on the user's locale.
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', ''), // English, no country code
            ],

            // Use AppLocalizations to configure the correct application title
            // depending on the user's locale.
            //
            // The appTitle is defined in .arb files found in the localization
            // directory.
            onGenerateTitle: (BuildContext context) =>
                AppLocalizations.of(context)!.appTitle,

            // Define a dark color theme only. It's hard enough getting one set
            // of colors right.
            theme: ThemeData.from(
              colorScheme: ColorScheme.dark(
                primary: Colors.blueGrey.shade600,
                primaryVariant: Colors.blueGrey.shade800,
                secondary: Colors.grey.shade800,
                secondaryVariant: Colors.grey.shade900,
                surface: const Color(0xFF061218),
                background: const Color(0xFF061218),
                // background: Color(0xFF212525),
                error: const Color(0xffe1bbc9),
              ),
            ),

            // Define a function to handle named routes in order to support
            // Flutter web url navigation and deep linking.
            onGenerateRoute: (RouteSettings routeSettings) {
              return MaterialPageRoute<void>(
                settings: routeSettings,
                builder: (BuildContext context) {
                  switch (routeSettings.name) {
                    case SettingsView.routeName:
                      return SettingsView(controller: settingsController);
                    case ThreadListView.routeName:
                    default:
                      return ThreadListView(
                        threadController: threadController,
                        userController: userController,
                      );
                  }
                },
              );
            },
          ),
        );
      },
    );
  }
}
