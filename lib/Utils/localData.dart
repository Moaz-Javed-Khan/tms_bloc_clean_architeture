import 'package:project_cleanarchiteture/Utils/Extensions.dart';
import 'package:shared_preferences/shared_preferences.dart';

mixin class LocalData {
  Future setUserinfo(String userdata) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(USER_INFO, userdata);
    print(userdata);
  }

  String? savedLoginData;

  Future<void> getUserinfo(String userdata) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    savedLoginData = prefs.getString(userdata);

    print(savedLoginData);
  }

  Future<void> clearSharedPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
