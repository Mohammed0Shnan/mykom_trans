import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:my_kom/abstracts/module/my_module.dart';
import 'package:my_kom/module_shoping/screen/shop_screen.dart';
import 'package:my_kom/module_shoping/shoping_routes.dart';

class ShopingModule extends MyModule {
  final ShopScreen _shopScreen;
  ShopingModule(this._shopScreen);
  @override
  Map<String, WidgetBuilder> getRoutes() => {
        ShopingRoutes.SHOPE_SCREEN: (context) =>_shopScreen,
      };
}
