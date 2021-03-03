import 'package:cloud_functions/cloud_functions.dart';
import '../models/sickReason.dart';
import '../utilities/authService.dart';

class FunctionService {
  static Future<void> notifyContactedUsers(SickReason sickReason) {
    final data = {
      'userId': AuthService.userId,
      'sickReason': sickReason.toString(),
      'timeOfSickness': DateTime.now().toString()
    };

    FirebaseFunctions.instance.httpsCallable('notifyContactedUsers').call(data);
  }
}