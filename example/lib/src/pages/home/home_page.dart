import 'package:example/src/pages/home/widgets/widgets.dart';
import 'package:example/src/routes/route_names.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Just Motion Demo'),
      ),
      body: Container(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            HomePageListItem(
              title: 'List items',
              route: RouteName.list,
            ),
            HomePageListItem(
              title: 'Floating Action Button Menu',
              route: RouteName.floatingActionButtonMenu,
            ),
            HomePageListItem(
              title: 'Simple Button',
              route: RouteName.simple_button,
            ),
          ],
        ),
      ),
    );
  }
}
