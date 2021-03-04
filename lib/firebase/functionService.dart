import 'package:cloud_functions/cloud_functions.dart';
import '../utilities/contactTracingUtilities.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import '../models/sickReason.dart';
import '../utilities/authService.dart';

class FunctionService {

  static void init(BuildContext context) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if(message.notification != null) {
        ContactTracingUtilities.sendContactTracingAlert(context, message.notification.body);
      }
    });
  }

  static Future<RemoteMessage> getInitialMessage() async {
    return await FirebaseMessaging.instance.getInitialMessage();
  }
  static void notifyContactedUsers(SickReason sickReason) {
    final data = {
      'userId': AuthService.userId,
      'sickness': sickReason.toString(),
    };

    FirebaseFunctions.instance.httpsCallable('notifyContactedUsers').call(data);
  }
}