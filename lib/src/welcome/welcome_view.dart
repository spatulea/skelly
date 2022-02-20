import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../debug/debug.dart';
import '../user/user_controller.dart';
import 'rotating_strfsh.dart';

class WelcomeView extends StatelessWidget {
  static const _className = 'WelcomeView';
  const WelcomeView(this.userController, {Key? key}) : super(key: key);
  static const routeName = '/welcome';
  final UserController userController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 300,
          height: 500,
          // color: Colors.pink,
          child: Column(
            children: [
              const RotatingStrfsh(),
              const SizedBox(height: 80),
              Text(
                'Welcome to strfsh',
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(fontSize: 26),
              ),
              const SizedBox(height: 20),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(children: [
                  const TextSpan(text: 'Read the '),
                  TextSpan(
                      text: 'Privacy Policy',
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: Theme.of(context).colorScheme.primary),
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
                  const TextSpan(
                      text: '. Tap "Agree & Continue" to accept the '),
                  TextSpan(
                      text: 'Terms of Service',
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: Theme.of(context).colorScheme.primary),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          const link =
                              'https://www.apple.com/legal/internet-services/itunes/dev/stdeula/';
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
                  const TextSpan(text: '.'),
                ]),
              ),
              const SizedBox(height: 40),
              TextButton(
                  onPressed: () => userController.agreeToTerms(),
                  child: Text('Agree & Continue',
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 20))),
            ],
          ),
        ),
      ),
    );
  }
}
