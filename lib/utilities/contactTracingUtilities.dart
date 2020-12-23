import 'package:covid_19_contact_tracing_app/messageModel.dart';
import 'package:covid_19_contact_tracing_app/sharedPreferences.dart';
import 'package:covid_19_contact_tracing_app/sickReason.dart';
import 'package:covid_19_contact_tracing_app/utilities/authService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ContactTracingUtilities {
  static const _platform = const MethodChannel('nearby-message-api');
  
  static void init() {
    _platform.setMethodCallHandler(_receivedMessage);
  }

  static Future<void> _receivedMessage(MethodCall call) async {
    if(call.method == "messageReceived"){
      Message receivedMessage = Message.fromJsonString(call.arguments('message'));
      if(receivedMessage.sick){
        //add to sqlite db
      }
    }
  }

  static Future<void> _mediumImpact() async {
    await SystemChannels.platform.invokeMethod<void>(
      'HapticFeedback.vibrate',
      'HapticFeedbackType.mediumImpact',
    );
  }

  static SnackBar _makeSnackBar(
      BuildContext context, String text, Color backgroundColor) {
    return SnackBar(
      content: Text(
        text,
        style:
            Theme.of(context).textTheme.bodyText2.copyWith(color: Colors.white),
      ),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
    );
  }

  static Future<void> toggleContactTracing(
      BuildContext context, bool shouldTrace) async {
    try {
      await _platform.invokeMethod(
          'toggleContactTracing', <String, bool>{'shouldTrace': shouldTrace});
      UserPreferences.setContactTracingPreference(shouldTrace);
      if (shouldTrace) {
        final snackBar =
            _makeSnackBar(context, 'Contact Tracing Enabled', Colors.blue);
        Scaffold.of(context).showSnackBar(snackBar);
      } else {
        final snackBar =
            _makeSnackBar(context, 'Contact Tracing Disabled', Colors.blue);
        Scaffold.of(context).showSnackBar(snackBar);
      }
      await _mediumImpact();
    } on PlatformException catch (e) {
      final snackBar = _makeSnackBar(context, e.message, Colors.red);
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  static void publishNotSick(BuildContext context) {
    Message noSickMessage = Message(userId: AuthService.userId, sick: false);
    _publish(context, noSickMessage);
  }

  static void publishSymptoms(BuildContext context, DateTime symptomsStartDate) {
    Message symptomMessage =
        Message(userId: AuthService.userId, sick: true, reason: SickReason.SYMPTOMS, symptomsStartDate: symptomsStartDate);
    _publish(context, symptomMessage);
  }

  static void publishPositiveTest(BuildContext context) {
    Message positiveTestMessage =
        Message(userId: AuthService.userId, sick: true, reason: SickReason.POSITIVE_TEST);
    _publish(context, positiveTestMessage);
  }

  static void _publish(BuildContext context, Message message) async {
    try {
      await _platform.invokeMethod(
          'publish', <String, String>{'message': message.toJsonString()});
    } on PlatformException catch (e) {
      final snackBar = _makeSnackBar(context, e.message, Colors.red);
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }
}
