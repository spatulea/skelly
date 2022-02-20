import 'package:flutter/material.dart';

class RotatingStrfsh extends StatefulWidget {
  const RotatingStrfsh({Key? key}) : super(key: key);

  @override
  _RotatingStrfshState createState() => _RotatingStrfshState();
}

class _RotatingStrfshState extends State<RotatingStrfsh>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(minutes: 1),
    vsync: this,
  )..repeat();

  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeInOut,
  );

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
        turns: _animation,
        child: Image.asset(
          'assets/strfsh.png',
          height: 200,
          color: Theme.of(context).colorScheme.primary,
        ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
