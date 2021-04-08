import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import '../utilities/contactTracingUtilities.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../models/sickReason.dart';
import 'authService.dart';

// A service class that handles cloud function logic
class FunctionService {

  //notifies the user if a message of exposure is sent
  // uses the firebase_messaging library
  static void init(BuildContext context) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if(message.notification != null) {
        ContactTracingUtilities.sendContactTracingAlert(context, message.notification.body);
      }
    });
  }

  //checks if there is a pending message from the back-end
  //uses the firebase_messaging library
  static Future<RemoteMessage> getInitialMessage() async {
    return await FirebaseMessaging.instance.getInitialMessage();
  }

  //calls the "notifyContactedUsers" cloud function to notify contacted users
  //uses the cloud_functions library
  static void notifyContactedUsers(SickReason sickReason) {
    final data = {
      'userId': AuthService.userId,
      'sickness': sickReason.toString(),
    };
    FirebaseFunctions.instance.httpsCallable('notifyContactedUsers').call(data);
  }
}