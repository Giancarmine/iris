import 'package:flutter/material.dart';
import 'package:iris/utils/theme.dart';

class MyButton extends StatelessWidget {
  final IconData? icon;
  final String? label;
  final Function()? onTap;
  final Color color;

  const MyButton(
      {Key? key,
      this.icon,
      this.label,
      required this.onTap,
      this.color = primaryClr})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        width: 120,
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(
                icon!,
                size: 20,
                color: Colors.white,
              ),
            ],
            if (label != null) ...[
              Text(
                label!,
                style: const TextStyle(color: Colors.white),
              )
            ]
          ],
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: color,
        ),
      ),
    );
  }
}
