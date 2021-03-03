import 'package:cloud_firestore/cloud_firestore.dart';
import '../utilities/authService.dart';

class FirestoreService {

  static final CollectionReference _db = FirebaseFirestore.instance.collection('users');

  static void addContact(String fcmToken, String timestamp) {
    final String userId = AuthService.userId;
    _db.doc(userId).collection('ContactedUsers').doc(fcmToken).set({
      'timeOfContact': timestamp,
    });
  }

  static void addUser(String userId) async {
    print('hi');
    await _db.doc(userId).set({});
  }

  static Future<bool> hasContacts() async {
    final String userId = AuthService.userId;
    final QuerySnapshot contactedUsers = await _db.doc(userId).collection('ContactedUsers').get();
    print(contactedUsers.size);
    return contactedUsers.size > 0;
  }
}