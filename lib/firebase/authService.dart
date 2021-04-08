import 'package:firebase_auth/firebase_auth.dart';

import 'firestoreService.dart';

// Service class that handles interactions with Firebase authentication
// This classes uses the firebase_auth library
class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  //get the current user object
  static User get user => _auth.currentUser;

  //get the current user id
  static String get userId => _auth.currentUser.uid;

  //if there user is not registered, sign in anonymously
  static Future<void> signInAnonIfNew() async {
    if (FirebaseAuth.instance.currentUser == null) {
      final UserCredential userCredential =
      await FirebaseAuth.instance.signInAnonymously();
      FirestoreService.addUser(userCredential.user.uid);
    }
  }
}