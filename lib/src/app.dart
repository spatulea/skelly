import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:skelly/src/message/thread_controller.dart';
import 'package:skelly/src/user/user_controller.dart';

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
        return MaterialApp(
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

          // Define a light and dark color theme. Then, read the user's
          // preferred ThemeMode (light, dark, or system default) from the
          // SettingsController to display the correct theme.
          // theme: ThemeData(
          //     brightness: Brightness.light,
          //     primarySwatch: Colors.amber,
          //     backgroundColor: Colors.amber.shade100),
          theme: ThemeData.from(
            colorScheme: ColorScheme.dark(
              primary: Color(0xff3b6468),
              primaryVariant: Color(0xffbfd7ea),
              secondary: Color(0xff6c6f7f),
              secondaryVariant: Color(0xffe1bbc9),
              surface: Color(0xffbfd7ea),
              background: Color(0xff12130f),
              error: Color(0xffe1bbc9),
              // onBackground: Colors.green,
              // onPrimary: Colors.pinkAccent,
              // onSecondary: Colors.amberAccent,
              // onError: Colors.blueAccent,
              // onSurface: Colors.redAccent,
            ),
          ),
          // darkTheme: ThemeData.from(colorScheme: ColorScheme.dark()),

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
        );
      },
    );
  }
}

/// Darken a color by [percent] amount (100 = black)
// ........................................................
Color darken(Color c, [int percent = 10]) {
  assert(0 <= percent && percent <= 100);
  if (percent == 0) return c;
  var f = 1 - percent / 100;
  return Color.fromARGB(c.alpha, (c.red * f).round(), (c.green * f).round(),
      (c.blue * f).round());
}

/// Lighten a color by [percent] amount (100 = white)
// ........................................................
Color lighten(Color c, [int percent = 10]) {
  assert(0 <= percent && percent <= 100);
  if (percent == 0) return c;
  var p = percent / 100;
  return Color.fromARGB(
      c.alpha,
      c.red + ((255 - c.red) * p).round(),
      c.green + ((255 - c.green) * p).round(),
      c.blue + ((255 - c.blue) * p).round());
}
