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

  static void setSelfIsolation(bool isSelfIsolating) {
    _preferences.setBool('selfIsolation', isSelfIsolating);
  }

  static Preference<bool> isSelfIsolating() {
    return _preferences.getBool('selfIsolation', defaultValue: false);
  }

  static void setSelfIsolationDuration(Duration duration) {
      _preferences.setInt('selfIsolationDuration', duration.inHours);
  }

  static Preference<int> getSelfIsolationDuration() {
    return _preferences.getInt('selfIsolationDuration', defaultValue: 0);
  }
}