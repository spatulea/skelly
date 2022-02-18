import 'package:flutter/material.dart';

class WelcomeView extends StatelessWidget {
  static const _className = 'WelcomeView';
  const WelcomeView({Key? key}) : super(key: key);

  static const routeName = '/welcome';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 100,
          height: 200,
          color: Colors.pink,
          child: Column(
            children: [
              Text('someText'),
              TextButton(onPressed: () {}, child: Text('Continue')),
            ],
          ),
        ),
      ),
    );
  }
}
