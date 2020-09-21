import 'package:flutter_firebase_login/authenticator/AuthenticatorService.dart';

class AuthService {
  static void initialize() {
    AuthenticatorService.initialize();
  }

  static String getAuthType() {
    return AuthenticatorService.getAuthType();
  }

  static String userId() {
    return AuthenticatorService._firebaseUser.uid;
  }

  static Future<dynamic> signInWithGoogle() async {
    return AuthenticatorService.signInWithGoogle();
  }

  static Future<dynamic> signInWithFacebook() async {
    return AuthenticatorService.signInWithFacebook();
  }

  static Future<dynamic> signInWithTwitter(
      String consumerKey, String consumerSecret) async {
    return AuthenticatorService.signInWithTwitter(consumerKey, consumerSecret);
  }

  static Future<Null> signOut(Function callback) async {
    await AuthenticatorService.signOut(callback);
  }

  static Future<void> deleteUser(Function callback) async {
    await AuthenticatorService.deleteUser(callback);
  }
}
