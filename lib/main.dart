//widget is object that describe part of user interface
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/landing_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<AuthBase>(
      //type annotation required in triangular brackets
      create: (context) => Auth(), //instance of auth
      child: MaterialApp(
        //provider takes child
        title: 'Time Tracker',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: LandingPage(),
      ),
    );
  }
}
