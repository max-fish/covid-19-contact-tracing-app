import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static void setContactTracingPreference(bool tracePref) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("contactTracing", tracePref);
  }

  static Future<bool> getContactTracingPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool("contactTracing");
  }
}