import 'package:cloud_firestore/cloud_firestore.dart';
import 'authService.dart';

class FirestoreService {

  static final CollectionReference _db = FirebaseFirestore.instance.collection('users');

  static void addContact(String fcmToken, String timestamp, String sickReason) {
    final String userId = AuthService.userId;
    _db.doc(userId).collection('ContactedUsers').doc(fcmToken).set({
      'timeOfContact': timestamp,
      'reason': sickReason
    });
  }

  static void addUser(String userId) async {
    await _db.doc(userId).set({});
  }

  static Future<bool> hasContacts() async {
    final String userId = AuthService.userId;
    final QuerySnapshot contactedUsers = await _db.doc(userId).collection('ContactedUsers').get();
    return contactedUsers.size > 0;
  }

  static Stream<QuerySnapshot> getContactsStream() {
    final String userId = AuthService.userId;
    final Stream<QuerySnapshot> contactedUsersStream = _db.doc(userId).collection('ContactedUsers').snapshots();
    return contactedUsersStream;
  }
}