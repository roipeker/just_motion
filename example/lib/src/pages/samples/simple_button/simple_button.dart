import 'package:flutter/material.dart';

import 'widgets/simple_button.dart';

class SimpleButtonPage extends StatefulWidget {
  const SimpleButtonPage({Key? key}) : super(key: key);

  @override
  _SimpleButtonPageState createState() => _SimpleButtonPageState();
}

class _SimpleButtonPageState extends State<SimpleButtonPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple stateless button'),
      ),
      body: Center(child: SimpleButton()),
    );
  }
}
