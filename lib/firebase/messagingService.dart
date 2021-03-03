import 'package:firebase_messaging/firebase_messaging.dart';

class MessagingService {
  static final _messaging = FirebaseMessaging.instance;

  static String token;

  static init() async {
    token = await _messaging.getToken(
        vapidKey: 'BFUirOboC8dAGQXoK91EJjJrizjEV07nq8oormkf2zioy_gBGgMm8SbL83Xmh0PK-hmoFUdMBGDPd1ih0N1vW18');
  }

  static requestPermission() async {
    final NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    return settings;
  }
}