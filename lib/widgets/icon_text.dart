import 'package:flutter/material.dart';

class IconText extends StatelessWidget {
  const IconText({
    Key? key,
    required this.icon,
    required this.color,
    required this.text,
    required this.textColor,
  }) : super(key: key);

  final String text;
  final IconData icon;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: color,
          size: 14,
        ),
        Text(
          text,
          style: Theme.of(context)
              .textTheme
              .caption!
              .copyWith(color: textColor, fontSize: 14),
        ),
      ],
    );
  }
}
