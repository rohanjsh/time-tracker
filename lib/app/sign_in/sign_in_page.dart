import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app/sign_in/email_sign_in_page.dart';
import 'package:time_tracker_flutter_course/app/sign_in/sign_in_button.dart';
import 'package:time_tracker_flutter_course/app/sign_in/social_sign_in_button.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key key, @required this.auth}) : super(key: key);
  // final void Function(User) onSignIn; //callback generation
  final AuthBase auth;

  Future<void> _signInAnonymously() async {
    try {
      await auth.signInAnonymously();
      // onSignIn(user); //calling
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _signInWithGoogle() async {
    try {
      await auth.signInWithGoogle();
      // onSignIn(user); //calling
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _signInWithFacebook() async {
    try {
      await auth.signInWithFacebook();
      // onSignIn(user); //calling
    } catch (e) {
      print(e.toString());
    }
  }

  void _signInWithEmail(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      fullscreenDialog: true, //for ios bottom up
      builder: (context) => EmailSignInPage(
        auth: auth,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Time Tracker'),
        elevation: 2.0,
      ),
      body: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    //underscore is private - accessible in file level itself
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Sign In',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: 48.0,
          ),
          SocialSignInButton(
            assetName: 'images/google-logo.png',
            text: 'Sign In with Google',
            textColor: Colors.white,
            color: Colors.black87,
            onPressed: _signInWithGoogle,
          ),
          SizedBox(
            height: 8.0,
          ),
          SocialSignInButton(
            assetName: 'images/facebook-logo.png',
            text: 'Sign In with Facebook',
            textColor: Colors.white,
            color: Color(0xff334D92),
            onPressed: _signInWithFacebook,
          ),
          SizedBox(
            height: 8.0,
          ),
          SignInButton(
            text: 'Sign In with Email',
            textColor: Colors.white,
            color: Colors.green[600],
            onPressed: () => _signInWithEmail(context),
          ),
          SizedBox(
            height: 8.0,
          ),
          Text(
            'or',
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 8.0,
          ),
          SignInButton(
            text: 'Sign In Anonymously',
            textColor: Colors.black87,
            color: Colors.tealAccent,
            onPressed: _signInAnonymously,
          ),
        ],
      ),
    );
  }
}
