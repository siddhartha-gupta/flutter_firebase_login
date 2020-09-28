import 'package:flutter_shared_codebase/flutter_shared_codebase.dart';

class AuthenticatorStore {
  static String _authType;
  static String twitterConsumerKey;
  static String twitterConsumerSecret;
  static bool googleEnabled;
  static bool facebookEnabled;
  static bool twitterEnabled;

  static void initialize(
    bool googleEnabled,
    bool facebookEnabled,
    bool twitterEnabled,
    String twitterConsumerKey,
    String twitterConsumerSecret,
  ) async {
    var authType = await LocalStorageService.getItem('loginState');
    await setAuthType(authType ?? '');
    AuthenticatorStore.googleEnabled = googleEnabled;
    AuthenticatorStore.facebookEnabled = facebookEnabled;
    AuthenticatorStore.twitterEnabled = twitterEnabled;
    AuthenticatorStore.twitterConsumerKey = twitterConsumerKey;
    AuthenticatorStore.twitterConsumerSecret = twitterConsumerSecret;
  }

  static Future<void> setAuthType(final String authType) async {
    if (authType == '') {
      await LocalStorageService.deleteItem('loginState');
    } else {
      await LocalStorageService.setItem('loginState', authType);
    }
    _authType = authType;
  }

  static String getAuthType() {
    return _authType;
  }
}
