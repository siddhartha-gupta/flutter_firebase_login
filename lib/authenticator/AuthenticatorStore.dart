import 'package:flutter_shared_codebase/flutter_shared_codebase.dart';

class AuthenticatorStore {
  static bool _googleEnabled = false;
  static bool _facebookEnabled = false;
  static bool _twitterEnabled = false;
  static String _twitterConsumerKey = '';
  static String _twitterConsumerSecret = '';
  static String _authType;

  static void initialize(
    final bool googleEnabled,
    final bool facebookEnabled,
    final bool twitterEnabled,
    final String twitterConsumerKey,
    final String twitterConsumerSecret,
  ) {
    _facebookEnabled = facebookEnabled;
    _googleEnabled = googleEnabled;
    _twitterEnabled = twitterEnabled;
    _twitterConsumerKey = twitterConsumerKey;
    _twitterConsumerSecret = twitterConsumerSecret;
    setAuthType(SharedPreferencesService.getString('loginState') ?? null);
  }

  static bool isGoogleEnabled() {
    return _googleEnabled;
  }

  static bool isFacebookEnabled() {
    return _facebookEnabled;
  }

  static bool isTwitterEnabled() {
    return _twitterEnabled;
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
