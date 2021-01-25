import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {

  static void setContactTracingPreference(bool tracePref) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('contactTracing', tracePref);
  }

  static Future<bool> getContactTracingPreference() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('contactTracing');
  }

  static void setSelfIsolation(bool isSelfIsolating) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('selfIsolation', isSelfIsolating);
  }

  static Future<bool> isSelfIsolating() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('selfIsolation') ?? false;
  }

  static void setSelfIsolationDuration(Duration duration) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt('selfIsolationDuration', duration.inHours);
  }

  static Future<int> getSelfIsolationDuration() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('selfIsolationDuration') ?? 0;
  }
}