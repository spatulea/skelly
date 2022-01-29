import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  const RoundButton({
    Key? key,
    required this.iconData,
    this.size = 26,
    this.iconSize,
    this.color,
    this.onSubmit,
  }) : super(key: key);

  final VoidCallback? onSubmit;
  final double size;
  final double? iconSize;
  final IconData iconData;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        child: Container(
          width: size,
          height: size,
          padding: const EdgeInsets.all(0),
          decoration: BoxDecoration(
            color: color ?? Theme.of(context).backgroundColor,
            borderRadius: BorderRadius.circular(size / 2),
          ),
          child: Icon(
            iconData,
            size: iconSize ?? size,
            color: Colors.grey.shade100,
          ),
        ),
        onTap: onSubmit ?? () {},
      ),
    );
  }
}
