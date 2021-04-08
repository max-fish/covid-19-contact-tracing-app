import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

// Utility class that handles business logic for user preferences
// This class uses the streaming_shared_preferences library
class UserPreferences {

  static StreamingSharedPreferences _preferences;

  static void init() async {
    _preferences = await StreamingSharedPreferences.instance;
  }

  //has the user expressed a preference for contact tracing before?
  static bool containsContactTracing() {
    return _preferences.getKeys().getValue().contains('contactTracing');
  }

  //set the user contact tracing preference
  static void setContactTracingPreference(bool tracePref) {
    _preferences.setBool('contactTracing', tracePref);
  }

  //get the user contact tracing preference
  static Preference<bool> getContactTracingPreference() {
    return _preferences.getBool('contactTracing', defaultValue: false);
  }
}