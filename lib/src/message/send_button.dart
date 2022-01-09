import 'package:flutter/material.dart';

class SendButton extends StatelessWidget {
  const SendButton({
    Key? key,
    required this.iconData,
    this.width = 26,
    this.height = 26,
    this.onSubmit,
  }) : super(key: key);

  final VoidCallback? onSubmit;
  final double width;
  final double height;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: width,
        height: height,
        padding: const EdgeInsets.all(0),
        decoration: BoxDecoration(
          color: Colors.blue,
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
