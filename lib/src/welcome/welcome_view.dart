import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:skelly/src/user/user_controller.dart';

class WelcomeView extends StatelessWidget {
  static const _className = 'WelcomeView';
  const WelcomeView(this.userController, {Key? key}) : super(key: key);
  static const routeName = '/welcome';
  final UserController userController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 100,
          height: 200,
          // color: Colors.pink,
          child: Column(
            children: [
              Text('someText'),
              MaterialButton(
                  onPressed: () => userController.agreeToTerms(),
                  child: Text('Continue')),
            ],
          ),
        ),
      ),
    );
  }
}
