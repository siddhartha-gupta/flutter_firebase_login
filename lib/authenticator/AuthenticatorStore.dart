import 'package:flutter_shared_codebase/flutter_shared_codebase.dart';

class AuthenticatorStore {
  static String _authType;
  static String twitterConsumerKey;
  static String twitterConsumerSecret;
  static bool googleEnabled;
  static bool facebookEnabled;
  static bool twitterEnabled;

  static Future<void> initialize(
    bool googleEnabled,
    bool facebookEnabled,
    bool twitterEnabled,
    String twitterConsumerKey,
    String twitterConsumerSecret,
  ) async {
    await SharedPreferencesService.isReady();
    print('SharedPreferencesService is ready');

    setAuthType(SharedPreferencesService.getString('loginState') ?? '');

    AuthenticatorStore.googleEnabled = googleEnabled;
    AuthenticatorStore.facebookEnabled = facebookEnabled;
    AuthenticatorStore.twitterEnabled = twitterEnabled;
    AuthenticatorStore.twitterConsumerKey = twitterConsumerKey;
    AuthenticatorStore.twitterConsumerSecret = twitterConsumerSecret;
  }

  static void setAuthType(final String authType) async {
    if (authType == '') {
      SharedPreferencesService.deleteItem('loginState');
    } else {
      SharedPreferencesService.setString('loginState', authType);
    }
    _authType = authType;
  }

  static String getAuthType() {
    return _authType;
  }
}
