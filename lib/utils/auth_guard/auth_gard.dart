// //
// import 'package:tut/module_persistence/sharedpref/shared_preferences_helper.dart';

import 'package:my_kom/module_persistence/sharedpref/shared_preferences_helper.dart';

class AuthGuard {
// final SharedPreferencesHelper _sharedPreferencesHelper = SharedPreferencesHelper();

 //AuthGuard(this._sharedPreferencesHelper);

 Future<bool> isLoggedIn() async {
  // var user = await _sharedPreferencesHelper.getUserUID();
  await Future.delayed(Duration(seconds: 1),);

 // return  user == null ? false : true; 
 // await Future.delayed(Duration(milliseconds: 400));
  return true;
  //return user != null;
 }
}
