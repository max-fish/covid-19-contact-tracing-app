import '../firebase/functionService.dart';
import '../firebase/messagingService.dart';
import '../firebase/firestoreService.dart';
import '../models/messageModel.dart';
import 'userPreferences.dart';
import '../models/sickReason.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ContactTracingUtilities {
  static const _platform = const MethodChannel('nearby-message-api');
  
  static void init() {
    _platform.setMethodCallHandler(_receivedMessage);
  }

  static Future<void> _receivedMessage(MethodCall call) async {
    if(call.method == 'messageReceived'){
      final Message receivedMessage = Message.fromJsonString(call.arguments('message'));
      final currentTime = DateTime.now().toString();
      await FirestoreService.addContact(receivedMessage.fcmToken, currentTime);
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
    final Message noSickMessage = Message(fcmToken: MessagingService.token, sick: false);
    _publish(context, noSickMessage);
  }

  static void publishSymptoms(BuildContext context, DateTime symptomsStartDate) {
    final Message symptomMessage =
        Message(fcmToken: MessagingService.token, sick: true, reason: SickReason.SYMPTOMS, symptomsStartDate: symptomsStartDate);
    _publish(context, symptomMessage);
    _notifyContactedUsersHandler(SickReason.SYMPTOMS);
  }

  static void publishPositiveTest(BuildContext context) {
    final Message positiveTestMessage =
        Message(fcmToken: MessagingService.token, sick: true, reason: SickReason.POSITIVE_TEST);
    _publish(context, positiveTestMessage);
    _notifyContactedUsersHandler(SickReason.POSITIVE_TEST);
  }

  static void sendContactTracingAlert(BuildContext context, String message) async {
    try {
      await _platform.invokeMethod('notifyContactTracing', <String, String>{'message': message});
    } on PlatformException catch (e) {
      final snackBar = _makeSnackBar(context, e.message, Colors.red);
      Scaffold.of(context).showSnackBar(snackBar);
    }
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

  static void _notifyContactedUsersHandler(SickReason sickReason) async {
    final bool hasContacts = await FirestoreService.hasContacts();
    if(hasContacts) {
      FunctionService.notifyContactedUsers(SickReason.SYMPTOMS);
    }
  }
}
