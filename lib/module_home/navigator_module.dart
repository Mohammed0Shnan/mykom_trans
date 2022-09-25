import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:my_kom/abstracts/module/my_module.dart';
import 'package:my_kom/module_home/navigator_routes.dart';
import 'package:my_kom/module_home/screen/home_screen.dart';
import 'package:my_kom/module_home/screen/navigator_screen.dart';
import 'package:my_kom/module_home/screen/shop_navigator_screen.dart';

class NavigatorModule extends MyModule {
  final NavigatorScreen _navigatorScreen;
  NavigatorModule(this._navigatorScreen);
  @override
  Map<String, WidgetBuilder> getRoutes() => {
        NavigatorRoutes.NAVIGATOR_SCREEN: (context) => _navigatorScreen,
      };
}
