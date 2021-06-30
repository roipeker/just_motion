import 'package:example/src/pages/pages.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'route_names.dart';

abstract class CustomRouter {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    return CupertinoPageRoute(builder: onRoute(settings));
  }

  static WidgetBuilder onRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteName.main:
        return (_) => HomePage();
      case RouteName.list:
        return (_) => ListPage();
      case RouteName.floatingActionButtonMenu:
        return (_) => ExampleExpandableFab();
    }
    return (_) => const SizedBox.shrink();
  }
}
