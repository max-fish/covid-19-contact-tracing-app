import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static final _auth = FirebaseAuth.instance;

  static String get userId {
    return _auth.currentUser.uid;
  }
}