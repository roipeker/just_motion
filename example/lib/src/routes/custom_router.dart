import 'package:example/src/pages/pages.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'route_names.dart';

abstract class CustomRouter {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    return CupertinoPageRoute(builder: (ctx) => onRoute(settings));
  }

  static Widget onRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteName.main:
        return HomePage();
      case RouteName.list:
        return ListPage();
    }
    return const SizedBox.shrink();
  }
}
