import 'package:example/src/widgets/palette.dart';
import 'package:flutter/material.dart';

import 'routes/routes.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Just Motion Demo',
      theme: ThemeData(
        primarySwatch: Palette.blue,
        accentColor: Palette.white,
        appBarTheme: AppBarTheme(
          centerTitle: false,
          brightness: Brightness.dark,
        ),
      ),
      initialRoute: RouteName.main,
      onGenerateRoute: CustomRouter.onGenerateRoute,
    );
  }
}
