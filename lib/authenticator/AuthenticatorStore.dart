import 'package:flutter_shared_codebase/flutter_shared_codebase.dart';

class AuthenticatorStore {
  static String _twitterConsumerKey = '';
  static String _twitterConsumerSecret = '';
  static String _authType;

  static void initialize(
    final String twitterConsumerKey,
    final String twitterConsumerSecret,
  ) {
    _twitterConsumerKey = twitterConsumerKey;
    _twitterConsumerSecret = twitterConsumerSecret;

    setAuthType(SharedPreferencesService.getString('loginState') ?? null);
  }

  static String getTwitterConsumerKey() {
    return _twitterConsumerKey;
  }

  static String getTwitterConsumerSecret() {
    return _twitterConsumerSecret;
  }

  static void setAuthType(final String authType) {
    _authType = authType;
  }

  static String getAuthType() {
    return _authType;
  }
}
