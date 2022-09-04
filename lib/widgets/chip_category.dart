import 'package:flutter/material.dart';

class ChipCategory extends StatelessWidget {
  const ChipCategory({
    Key? key,
    required this.category,
  }) : super(key: key);
  final String category;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 4),
      child: Chip(
        backgroundColor: Colors.amber,
        label: Text(
          category,
          style: Theme.of(context).textTheme.caption,
        ),
      ),
    );
  }
}
