import 'package:flutter_shared_codebase/flutter_shared_codebase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'AuthenticatorStore.dart';

class AuthenticatorService {
  static final GoogleSignIn _googleSignIn = new GoogleSignIn();
  static final FacebookLogin facebookSignIn = new FacebookLogin();
  static TwitterLogin twitterLogin;

  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static FirebaseUser _firebaseUser;

  static void initialize() {
    AuthenticatorStore.initialize();
  }

  static String getAuthType() {
    return AuthenticatorStore.getAuthType();
  }

  static Future<dynamic> signInWithGoogle() async {
    // Attempt to get the currently authenticated user

    GoogleSignInAccount currentUser = _googleSignIn.currentUser;
    if (currentUser == null) {
      // Attempt to sign in without user interaction
      currentUser = await _googleSignIn.signInSilently();
    }
    if (currentUser == null) {
      // Force the user to interactively sign in
      print('Force the user to interactively sign in');
      currentUser = await _googleSignIn.signIn();
    }

    print('GoogleSignInAuthentication auth');
    final GoogleSignInAuthentication googleAuth =
        await currentUser.authentication;

    // Authenticate with firebase
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    _firebaseUser = (await _auth.signInWithCredential(credential)).user;
    print("signed in " + _firebaseUser.displayName);

    AuthenticatorStore.setAuthType('googleplus');

    return _firebaseUser;
  }

  static Future<dynamic> signInWithFacebook() async {
    FacebookAccessToken currentSession =
        await facebookSignIn.currentAccessToken;

    if (currentSession != null) {
      final result = await firebaseFacebookAuth(new CustomFacebookSession(
        token: currentSession.token,
      ));
      return result;
    } else {
      final FacebookLoginResult authResult =
          await facebookSignIn.logIn(['email']);

      switch (authResult.status) {
        case FacebookLoginStatus.loggedIn:
          final FacebookAccessToken accessToken = authResult.accessToken;
          print('''
         Logged in!
         Token: ${accessToken.token}
         User id: ${accessToken.userId}
         Expires: ${accessToken.expires}
         Permissions: ${accessToken.permissions}
         Declined permissions: ${accessToken.declinedPermissions}
         ''');

          final result = await firebaseFacebookAuth(new CustomFacebookSession(
            token: accessToken.token,
          ));
          AuthenticatorStore.setAuthType('facebook');

          return result;
          break;

        case FacebookLoginStatus.cancelledByUser:
          print('Login cancelled by the user.');
          break;

        case FacebookLoginStatus.error:
          return 'Something went wrong with the login process.\n'
              'Here\'s the error Facebook gave us: ${authResult.errorMessage}';
          break;
      }
    }
  }

  static Future<dynamic> firebaseFacebookAuth(
      CustomFacebookSession facebookSession) async {
    // Authenticate with firebase
    final AuthCredential credential = FacebookAuthProvider.getCredential(
      accessToken: facebookSession.token,
    );

    try {
      AuthResult authResult = await _auth.signInWithCredential(credential);
      _firebaseUser = authResult.user;
      print("signed in " + _firebaseUser.displayName);
      return 'LoggedIn';
    } catch (e) {
      print("sign in failure " + e.code);
      if (e.code == 'ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL') {
        return 'Account already exist with different login provider';
      }
      return 'Oops! There was a error, please try again';
    }
  }

  static Future<dynamic> signInWithTwitter(
      String consumerKey, String consumerSecret) async {
    twitterLogin = new TwitterLogin(
      consumerKey: consumerKey,
      consumerSecret: consumerSecret,
    );

    TwitterSession currentSession = await twitterLogin.currentSession;

    if (currentSession != null) {
      final result = await firebaseTwitterAuth(new CustomTwitterSession(
        token: currentSession?.token ?? '',
        secret: currentSession?.secret ?? '',
      ));
      AuthenticatorStore.setAuthType('twitter');

      return result;
    } else {
      final TwitterLoginResult authResult = await twitterLogin.authorize();

      switch (authResult.status) {
        case TwitterLoginStatus.loggedIn:
          var session = authResult.session;

          final result = await firebaseTwitterAuth(new CustomTwitterSession(
            token: session?.token ?? '',
            secret: session?.secret ?? '',
          ));
          AuthenticatorStore.setAuthType('twitter');

          return result;

        case TwitterLoginStatus.cancelledByUser:
          print('Login cancelled by the user.');
          break;

        case TwitterLoginStatus.error:
          return 'Something went wrong with the login process.\n'
              'Here\'s the error twitter gave us: ${authResult.errorMessage}';
          break;
      }
    }
  }

  static Future<dynamic> firebaseTwitterAuth(
    CustomTwitterSession twitterSession,
  ) async {
    final AuthCredential credential = TwitterAuthProvider.getCredential(
      authToken: twitterSession.token,
      authTokenSecret: twitterSession.secret,
    );

    try {
      AuthResult authResult = await _auth.signInWithCredential(credential);

      _firebaseUser = authResult.user;

      print("signed in " + _firebaseUser.displayName);
      return 'LoggedIn';
    } catch (e) {
      print("sign in failure " + e.code);
      if (e.code == 'ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL') {
        return 'Account already exist with different login provider';
      }
      return 'Oops! There was a error, please try again';
    }
  }

  static Future<Null> signOut(Function callback) async {
    final String loginState = AuthenticatorStore.getAuthType();

    print('loginState: ' + loginState);
    switch (loginState) {
      case 'googleplus':
        await signOutFromGoogle();
        break;

      case 'facebook':
        await signOutFromFacebook();
        break;

      case 'twitter':
        await signOutFromTwitter();
        break;
    }
    SharedPreferencesService.deleteItem('loginState');
    AuthenticatorStore.setAuthType('');

    if (callback != null) {
      callback();
    }
  }

  static Future<Null> signOutFromGoogle() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }

  static Future<Null> signOutFromFacebook() async {
    await _auth.signOut();
    await facebookSignIn.logOut();
  }

  static Future<Null> signOutFromTwitter() async {
    await _auth.signOut();
    await twitterLogin.logOut();
  }

  static Future<void> deleteUser(Function callback) async {
    await _firebaseUser.delete();

    if (callback != null) {
      callback();
    }
  }
}

class CustomFacebookSession {
  final String token;

  CustomFacebookSession({this.token});
}

class CustomTwitterSession {
  final String secret;
  final String token;

  CustomTwitterSession({this.secret, this.token});
}
