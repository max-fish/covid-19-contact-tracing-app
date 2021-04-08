import 'package:cloud_firestore/cloud_firestore.dart';
import 'authService.dart';

// A service class that handles database storage logic
class FirestoreService {

  static final CollectionReference _db = FirebaseFirestore.instance.collection('users');

  //add a user to the list of contacts
  static void addContact(String fcmToken, String timestamp, String sickReason) {
    final String userId = AuthService.userId;
    _db.doc(userId).collection('ContactedUsers').doc(fcmToken).set({
      'timeOfContact': timestamp,
      'reason': sickReason
    });
  }

  //add the current user to the database
  static void addUser(String userId) async {
    await _db.doc(userId).set({});
  }

  //check if the current user has contacts
  static Future<bool> hasContacts() async {
    final String userId = AuthService.userId;
    final QuerySnapshot contactedUsers = await _db.doc(userId).collection('ContactedUsers').get();
    return contactedUsers.size > 0;
  }

  //get a stream of the current user's contacts
  static Stream<QuerySnapshot> getContactsStream() {
    final String userId = AuthService.userId;
    final Stream<QuerySnapshot> contactedUsersStream = _db.doc(userId).collection('ContactedUsers').snapshots();
    return contactedUsersStream;
  }
}