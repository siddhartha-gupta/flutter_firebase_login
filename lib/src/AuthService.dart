import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_firebase_login/authenticator/AuthenticatorService.dart';
import 'package:flutter_firebase_login/authenticator/AuthenticatorStore.dart';

class AuthService {
  static Future<bool> initialize(
    bool googleEnabled,
    bool facebookEnabled,
    bool twitterEnabled,
    String twitterConsumerKey,
    String twitterConsumerSecret,
  ) async {
    await Firebase.initializeApp();

    await AuthenticatorStore.initialize(
      googleEnabled,
      facebookEnabled,
      twitterEnabled,
      twitterConsumerKey,
      twitterConsumerSecret,
    );

    return AuthenticatorService.checkLogin();
  }

  static String getAuthType() {
    return AuthenticatorService.getAuthType();
  }

  static String userId() {
    return AuthenticatorService.userId();
  }

  static String getAccessToken() {
    return AuthenticatorService.getAccessToken();
  }

  static Future<dynamic> signInWithGoogle() async {
    return AuthenticatorService.signInWithGoogle();
  }

  static Future<dynamic> signInWithFacebook() async {
    return AuthenticatorService.signInWithFacebook();
  }

  static Future<dynamic> signInWithTwitter() async {
    return AuthenticatorService.signInWithTwitter();
  }

  static Future<Null> signOut(Function callback) async {
    await AuthenticatorService.signOut(callback);
  }

  static Future<void> deleteUser(Function callback) async {
    await AuthenticatorService.deleteUser(callback);
  }
}
