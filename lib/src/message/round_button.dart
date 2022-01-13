import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  const RoundButton({
    Key? key,
    required this.iconData,
    this.width = 26,
    this.height = 26,
    this.color = Colors.blue,
    this.onSubmit,
  }) : super(key: key);

  final VoidCallback? onSubmit;
  final double width;
  final double height;
  final IconData iconData;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: width,
        height: height,
        padding: const EdgeInsets.all(0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(13),
        ),
        child: Icon(
          iconData,
          color: Colors.grey.shade100,
        ),
      ),
      onTap: onSubmit ?? () {},
    );
  }
}
