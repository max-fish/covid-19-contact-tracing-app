import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class UserPreferences {

  static StreamingSharedPreferences _preferences;

  static void init() async {
    _preferences = await StreamingSharedPreferences.instance;
  }

  static bool containsContactTracing() {
    return _preferences.getKeys().getValue().contains('contactTracing');
  }

  static void setContactTracingPreference(bool tracePref) {
    _preferences.setBool('contactTracing', tracePref);
  }

  static Preference<bool> getContactTracingPreference() {
    return _preferences.getBool('contactTracing', defaultValue: false);
  }
}