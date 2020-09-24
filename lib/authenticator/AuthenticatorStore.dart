import 'package:flutter_shared_codebase/flutter_shared_codebase.dart';

class AuthenticatorStore {
  static String _authType;
  static String twitterConsumerKey;
  static String twitterConsumerSecret;

  static void initialize(
    String twitterConsumerKey,
    String twitterConsumerSecret,
  ) {
    setAuthType(SharedPreferencesService.getString('loginState') ?? '');
    AuthenticatorStore.twitterConsumerKey = twitterConsumerKey;
    AuthenticatorStore.twitterConsumerSecret = twitterConsumerSecret;
  }

  static void setAuthType(final String authType) {
    if (authType == '') {
      SharedPreferencesService.deleteItem('loginState');
    } else {
      _authType = authType;
      SharedPreferencesService.setString('loginState', authType);
    }
  }

  static String getAuthType() {
    return _authType;
  }
}
