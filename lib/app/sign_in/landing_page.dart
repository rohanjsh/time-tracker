import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:time_tracker_flutter_course/app/sign_in/home_page.dart';
import 'package:time_tracker_flutter_course/app/sign_in/sign_in_page.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key key, @required this.auth}) : super(key: key);
  final AuthBase auth;

  // User _user;
  //all the comments before it was a stateful widget keep in mind
  // void _updateUser(User user) {
  //   setState(() {
  //     _user = user; //user variable outside function and at the argument level
  //   });
  // }
  //
  // @override
  // void initState() {
  //
  //   super.initState();
  //
  //   _updateUser(
  //       //widget.auth used to access the variable from outside the state class
  //       widget.auth.currentUser); //to check user is logged in or not
  // }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      //streams introduction
      stream: auth.authStateChanged(),

      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final User user = snapshot.data;
          if (user == null) {
            return SignInPage(
              auth: auth,
              //correct callback`q
            );
          }
          return HomePage(
            auth: auth,
          );
        }
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
    //communication between widgets by callbacks
  }
}
