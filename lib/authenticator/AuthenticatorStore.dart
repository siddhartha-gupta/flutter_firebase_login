import 'package:flutter_shared_codebase/flutter_shared_codebase.dart';

class AuthenticatorStore {
  static String _authType;

  static void initialize() {
    setAuthType(SharedPreferencesService.getString('loginState') ?? null);
  }

  static void setAuthType(final String authType) {
    _authType = authType;
  }

  static String getAuthType() {
    return _authType;
  }
}
