import 'package:flutter/material.dart';
import 'package:flutter_firebase_login/authenticator/AuthenticatorService.dart';
import 'package:flutter_firebase_login/authenticator/AuthenticatorStore.dart';
import 'package:flutter_shared_codebase/flutter_shared_codebase.dart';

class LoginPage extends StatefulWidget {
  final bool googleEnabled;
  final bool facebookEnabled;
  final bool twitterEnabled;
  final String twitterConsumerKey;
  final String twitterConsumerSecret;

  final Function loginComplete;
  final Function loginError;

  LoginPage({
    Key key,
    @required this.googleEnabled,
    @required this.facebookEnabled,
    @required this.twitterEnabled,
    @required this.twitterConsumerKey,
    @required this.twitterConsumerSecret,
    @required this.loginComplete,
    @required this.loginError,
  }) : super(key: key);

  @override
  State createState() => new LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  bool _loginInProgress = false;

  @override
  void initState() {
    super.initState();

    SharedPreferencesService.isReady().then((onValue) {
      AuthenticatorStore.initialize(
        widget.googleEnabled,
        widget.facebookEnabled,
        widget.twitterEnabled,
        widget.twitterConsumerKey,
        widget.twitterConsumerSecret,
      );
      _checkLogin();
    });
  }

  _checkLogin() async {
    final String loginState =
        (SharedPreferencesService.getString('loginState') ?? null);

    switch (loginState) {
      case 'googleplus':
        _googleLogin();
        break;

      case 'facebook':
        _facebookLogin();
        break;

      case 'twitter':
        _twitterLogin();
        break;
    }
  }

  _googleLogin() {
    if (_proceedLogin()) {
      AuthenticatorService.signInWithGoogle().then((user) {
        print('googleplus');
        _onLoginSuccess('googleplus');
      }).catchError((e) {
        print('error' + e.toString());
        _onLoginError('Oops! There was a error, please try again');
      });
    }
  }

  _facebookLogin() {
    if (_proceedLogin()) {
      AuthenticatorService.signInWithFacebook().then((result) {
        if (result == 'LoggedIn') {
          _onLoginSuccess('facebook');
        } else {
          _onLoginError(result);
        }
      }).catchError((e) {
        _onLoginError('Oops! There was a error, please try again');
      });
    }
  }

  _twitterLogin() {
    if (_proceedLogin()) {
      AuthenticatorService.signInWithTwitter().then((result) {
        if (result == 'LoggedIn') {
          _onLoginSuccess('twitter');
        } else {
          _onLoginError(result);
        }
      }).catchError((e) {
        _onLoginError(e);
      });
    }
  }

  bool _proceedLogin() {
    if (NetworkService.isNetworkDisconnected()) {
      setState(() {
        _loginInProgress = false;
      });
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('No internet connection')));

      return false;
    }

    if (!_loginInProgress) {
      _loginInProgress = true;
      setState(() {});
    }
    return true;
  }

  _onLoginSuccess(final String loginType) {
    widget.loginComplete();
    setState(() {
      _loginInProgress = false;
    });
  }

  _onLoginError(String msg) {
    print('error while logging');

    Scaffold.of(context).showSnackBar(SnackBar(content: Text(msg)));
    setState(() {
      _loginInProgress = false;
    });
    widget.loginError();
  }

  Widget _loginButton(title, uri,
      [color = const Color.fromRGBO(68, 68, 76, .8)]) {
    return Container(
      width: 200.0,
      child: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              uri,
              width: 25.0,
            ),
            Padding(
              child: Text(
                "Sign in with $title",
                style: TextStyle(
                  fontFamily: 'Roboto',
                  color: color,
                ),
              ),
              padding: new EdgeInsets.only(left: 15.0),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(body: new Builder(builder: (BuildContext context) {
      return _loginInProgress
          ? new LoadingIndicator()
          : new Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new RaisedButton(
                    child: _loginButton('Google', 'assets/images/google.png'),
                    onPressed: _googleLogin,
                    color: Colors.white,
                  ),
                  Padding(padding: EdgeInsets.all(10.0)),
                  new RaisedButton(
                    child: _loginButton(
                        'Facebook', 'assets/images/facebook.png', Colors.white),
                    onPressed: _facebookLogin,
                    color: Color.fromRGBO(58, 89, 152, 1.0),
                  ),
                  Padding(padding: EdgeInsets.all(10.0)),
                  new RaisedButton(
                    child: _loginButton(
                        'Twitter', 'assets/images/twitter.png', Colors.white),
                    onPressed: _twitterLogin,
                    color: Color.fromRGBO(56, 161, 243, 1.0),
                  ),
                ],
              ),
            );
    }));
  }
}
