import 'package:covid_19_contact_tracing_app/messageModel.dart';
import 'package:covid_19_contact_tracing_app/sharedPreferences.dart';
import 'package:covid_19_contact_tracing_app/sickReason.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ContactTracingUtilities {
  static const _platform = const MethodChannel('nearby-message-api');

  static Future<void> _mediumImpact() async {
    await SystemChannels.platform.invokeMethod<void>(
      'HapticFeedback.vibrate',
      'HapticFeedbackType.mediumImpact',
    );
  }

  static Future<void> toggleContactTracing(
      BuildContext context, bool shouldTrace) async {
    try {
      await _platform.invokeMethod(
          'toggleContactTracing', <String, bool>{'shouldTrace': shouldTrace});
      UserPreferences.setContactTracingPreference(shouldTrace);
      if (shouldTrace) {
        final snackBar = SnackBar(
          content: Text(
            'Contact Tracing Enabled',
            style: Theme.of(context)
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
              style: Theme.of(context)
                  .textTheme
                  .bodyText2
                  .copyWith(color: Colors.white)),
          behavior: SnackBarBehavior.floating,
        );
        Scaffold.of(context).showSnackBar(snackBar);
      }
      await _mediumImpact();
    } on PlatformException catch (e) {
      final snackBar = SnackBar(
        content: Text(
          e.message,
        ),
      );
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  static void publishNoSick(BuildContext context) {
    Message noSickMessage = Message(userId: "", sick: false);
    _publish(context, noSickMessage);
  }

  static void publishSymptoms(BuildContext context) {
    Message symptomMessage =
        Message(userId: "", sick: true, reason: SickReason.SYMPTOMS);
    _publish(context, symptomMessage);
  }

  static void publishPositiveTest(BuildContext context) {
    Message positiveTestMessage =
        Message(userId: "", sick: true, reason: SickReason.POSITIVE_TEST);
    _publish(context, positiveTestMessage);
  }

  static void _publish(BuildContext context, Message message) async {
    try {
      await _platform.invokeMethod(
          'publish', <String, String>{'message': message.toJsonString()});
    } on PlatformException catch (e) {
      final snackBar = SnackBar(
        content: Text(e.message),
      );
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }
}
