import 'package:my_kom/abstracts/module/my_module.dart';
import 'package:my_kom/module_authorization/screens/login_automatically.dart';
import 'package:my_kom/module_authorization/screens/login_screen.dart';
import 'package:my_kom/module_authorization/screens/register_screen.dart';
import 'package:flutter/cupertino.dart';
import 'authorization_routes.dart';

class AuthorizationModule extends MyModule {
   final LoginScreen _loginScreen  ;
   final RegisterScreen _registerScreen;

   AuthorizationModule(this._loginScreen,this._registerScreen);

  @override
  Map<String, WidgetBuilder> getRoutes() {
    return {
       AuthorizationRoutes.LOGIN_SCREEN : (context) => _loginScreen,
       AuthorizationRoutes.REGISTER_SCREEN : (context)=> _registerScreen,

    };
  }
}
