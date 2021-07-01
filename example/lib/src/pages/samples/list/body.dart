import 'package:flutter/material.dart';

import 'list.dart';

class ListPage extends StatefulWidget {
  ListPage({Key? key}) : super(key: key);

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final list = <String>[];
  bool _delayed = true;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 800), () {
      setState(() {
        _delayed = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    const gap18 = SizedBox(height: 18.0);
    return Scaffold(
      appBar: AppBar(
        title: const Text('List view'),
      ),
      body: Container(
        child: _delayed
            ? Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  ScaleWidget(),
                  gap18,
                  OpacityWidget(),
                  gap18,
                  HeightWidget(),
                  gap18,
                  ColorWidget(),
                  gap18,
                ],
              ),
      ),
    );
  }
}
