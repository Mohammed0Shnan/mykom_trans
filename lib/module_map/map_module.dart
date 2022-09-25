import 'package:my_kom/abstracts/module/my_module.dart';
import 'package:my_kom/module_authorization/screens/login_screen.dart';
import 'package:my_kom/module_authorization/screens/register_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_kom/module_map/screen/map_screen.dart';

import 'map_routes.dart';

class MapModule extends MyModule {
  final MapScreen _mapScreen  ;

  MapModule(this._mapScreen);

  @override
  Map<String, WidgetBuilder> getRoutes() {
    return {
      MapRoutes.MAP_SCREEN : (context) => _mapScreen,
    };
  }
}