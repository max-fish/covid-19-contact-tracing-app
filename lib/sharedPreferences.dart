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

  static void setSelfIsolation(bool isSelfIsolating) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("selfIsolation", isSelfIsolating);
  }

  static Future<bool> isSelfIsolating() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool("selfIsolation") ?? false;
  }

  static void setSelfIsolationDuration(Duration duration) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt("selfIsolationDuration", duration.inHours);
  }

  static Future<int> getSelfIsolationDuration() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt("selfIsolationDuration") ?? 0;
  }
}