import 'package:flutter/material.dart';

class MenuListTile extends StatelessWidget {
  final String name;
  final String imgUrl;
  final Function() onTap;
  const MenuListTile(
      {Key? key, required this.name, required this.imgUrl, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
          leading: Container(
            height: 60,
            width: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(imgUrl),
              ),
            ),
          ),
          contentPadding: const EdgeInsets.all(8),
          title: Text(name),
          trailing: ElevatedButton(
            onPressed: onTap,
            child: const Text('Buy'),
          )),
    );
  }
}
