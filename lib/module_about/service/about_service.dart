
import 'package:shared_preferences/shared_preferences.dart';


class AboutService {

  Future<bool> isInited() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool? inited = await preferences.getBool('inited');
    return inited != null;
  }

  Future<void> setInited() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setBool('inited', true);
  }
}