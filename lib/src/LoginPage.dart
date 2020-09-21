import 'package:flutter/material.dart';
import 'package:flutter_shared_codebase/flutter_shared_codebase.dart';
import 'package:flutter_firebase_login/src/AuthService.dart';

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
      AuthService.initialize();
      _checkLogin();
    });
  }

  _checkLogin() async {
    final String loginState = AuthService.getAuthType();

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
      AuthService.signInWithGoogle().then((user) {
        print('googleplus');
        _onLoginSuccess('googleplus');
      }).catchError((e) {
        print('error' + e.toString());
        _onLoginError(e, 'Oops! There was a error, please try again');
      });
    }
  }

  _facebookLogin() {
    if (_proceedLogin()) {
      AuthService.signInWithFacebook().then((result) {
        if (result == 'LoggedIn') {
          _onLoginSuccess('facebook');
        } else {
          _onLoginError(result);
        }
      }).catchError((e) {
        _onLoginError(e, 'Oops! There was a error, please try again');
      });
    }
  }

  _twitterLogin() {
    if (_proceedLogin()) {
      AuthService.signInWithTwitter(
        widget.twitterConsumerKey,
        widget.twitterConsumerSecret,
      ).then((result) {
        if (result == 'LoggedIn') {
          _onLoginSuccess('twitter');
        } else {
          _onLoginError(e, result);
        }
      }).catchError((e) {
        _onLoginError(e, 'Oops! There was a error, please try again');
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
    setState(() {
      _loginInProgress = false;
    });
    widget.loginComplete(loginType);
  }

  _onLoginError(dynamic error, String msg) {
    print('error while logging: ' + msg);

    Scaffold.of(context).showSnackBar(SnackBar(content: Text(msg)));
    setState(() {
      _loginInProgress = false;
    });
    widget.loginError(error);
  }

  List<Widget> _loginButton(title, icon, textColor, buttonColor, callback) {
    List<Widget> widgets = new List();

    widgets.add(new RaisedButton(
      child: Container(
        width: 200.0,
        child: Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                icon,
                width: 25.0,
              ),
              Padding(
                child: Text(
                  "Sign in with $title",
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    color: textColor,
                  ),
                ),
                padding: new EdgeInsets.only(left: 15.0),
              ),
            ],
          ),
        ),
      ),
      onPressed: callback,
      color: buttonColor,
    ));
    widgets.add(new Padding(padding: EdgeInsets.all(10.0)));

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Builder(
        builder: (BuildContext context) {
          return _loginInProgress
              ? new LoadingIndicator()
              : new Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      if (widget.googleEnabled)
                        ..._loginButton(
                          'Google',
                          'assets/images/google.png',
                          Color.fromRGBO(68, 68, 76, .8),
                          Colors.white,
                          _googleLogin,
                        ),
                      if (widget.facebookEnabled)
                        ..._loginButton(
                          'Facebook',
                          'assets/images/facebook.png',
                          Colors.white,
                          Color.fromRGBO(58, 89, 152, 1.0),
                          _facebookLogin,
                        ),
                      if (widget.twitterEnabled)
                        ..._loginButton(
                          'Twitter',
                          'assets/images/twitter.png',
                          Colors.white,
                          Color.fromRGBO(56, 161, 243, 1.0),
                          _twitterLogin,
                        ),
                    ],
                  ),
                );
        },
      ),
    );
  }
}
