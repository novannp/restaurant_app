import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class ReviewCard extends StatelessWidget {
  final String name;
  final String date;
  final String review;
  const ReviewCard({
    Key? key,
    required this.name,
    required this.date,
    required this.review,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const CircleAvatar(
          backgroundImage: NetworkImage('https://picsum.photos/200'),
        ),
        contentPadding: const EdgeInsets.all(14),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AutoSizeText(
              name,
              style: Theme.of(context).textTheme.headline6!.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
              maxLines: 1,
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              review,
            ),
            Text(date, maxLines: 1, style: Theme.of(context).textTheme.caption),
          ],
        ),
      ),
    );
  }
}
