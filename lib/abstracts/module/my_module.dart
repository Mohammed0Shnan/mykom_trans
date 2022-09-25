import 'package:flutter/material.dart';

abstract class MyModule {
  Map<String, WidgetBuilder> getRoutes();
}
