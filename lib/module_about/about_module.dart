
import 'package:flutter/cupertino.dart';
import 'package:my_kom/abstracts/module/my_module.dart';
import 'package:my_kom/module_about/about_routes.dart';
import 'package:my_kom/module_about/screen/language_screen.dart';

class AboutModule extends MyModule {
  LanguageScreen _languageScreen;
  AboutModule(this._languageScreen);
  @override
  Map<String, WidgetBuilder> getRoutes() {
    return {  AboutRoutes.ROUTE_ABOUT: (context) => _languageScreen};
  }
  }
