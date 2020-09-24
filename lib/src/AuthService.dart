import 'package:flutter_firebase_login/authenticator/AuthenticatorService.dart';
import 'package:flutter_shared_codebase/flutter_shared_codebase.dart';

class AuthService {
  static Future<bool> initialize(
    String twitterConsumerKey,
    String twitterConsumerSecret,
  ) async {
    await SharedPreferencesService.isReady();
    print('SharedPreferencesService is ready');

    AuthenticatorService.initialize(twitterConsumerKey, twitterConsumerSecret);

    return AuthenticatorService.checkLogin();
  }

  static String getAuthType() {
    return AuthenticatorService.getAuthType();
  }

  static String userId() {
    return AuthenticatorService.userId();
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
