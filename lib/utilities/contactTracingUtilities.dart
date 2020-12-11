import 'package:covid_19_contact_tracing_app/sharedPreferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ContactTracingUtilities {
  static const platform = const MethodChannel('nearby-message-api');

  static Future<void> mediumImpact() async {
    await SystemChannels.platform.invokeMethod<void>(
      'HapticFeedback.vibrate',
      'HapticFeedbackType.mediumImpact',
    );
  }

  static Future<void> toggleContactTracing(BuildContext context, bool shouldTrace) async {
    try {
      await platform.invokeMethod(
          'toggleContactTracing', <String, bool>{'shouldTrace': shouldTrace});
      UserPreferences.setContactTracingPreference(shouldTrace);
      if (shouldTrace) {
        final snackBar = SnackBar(
          content: Text(
            'Contact Tracing Enabled',
            style: Theme
                .of(context)
                .textTheme
                .bodyText2
                .copyWith(color: Colors.white),
          ),
          behavior: SnackBarBehavior.floating,
        );
        Scaffold.of(context).showSnackBar(snackBar);
      } else {
        final snackBar = SnackBar(
          content: Text(
              'Contact Tracing Disabled (You will not be alerted of possible exposure when using the app)',
              style: Theme
                  .of(context)
                  .textTheme
                  .bodyText2
                  .copyWith(color: Colors.white)),
          behavior: SnackBarBehavior.floating,
        );
        Scaffold.of(context).showSnackBar(snackBar);
      }
      await mediumImpact();
    } on PlatformException catch (e) {
      final snackBar = SnackBar(
        content: Text(
          e.message,
        ),
      );
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }
}