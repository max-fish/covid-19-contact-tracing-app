import 'package:firebase_auth/firebase_auth.dart';

import 'firestoreService.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static User get user => _auth.currentUser;

  static String get userId => _auth.currentUser.uid;

  static Future<void> signInAnonIfNew() async {
    if (FirebaseAuth.instance.currentUser == null) {
      final UserCredential userCredential =
      await FirebaseAuth.instance.signInAnonymously();
      FirestoreService.addUser(userCredential.user.uid);
    }
  }

  static Future<void> signInAnon() async {
    if (FirebaseAuth.instance.currentUser == null) {
      await FirebaseAuth.instance.signInAnonymously();
    }
  }
}