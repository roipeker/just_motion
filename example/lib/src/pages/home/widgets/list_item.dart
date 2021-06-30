import 'package:flutter/material.dart';

class HomePageListItem extends StatelessWidget {
  const HomePageListItem({
    Key? key,
    required this.title,
    required this.route,
  }) : super(key: key);
  final String title;

  final String route;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => Navigator.of(context).pushNamed(route),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios),
    );
  }
}
