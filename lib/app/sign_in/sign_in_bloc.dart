import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart'; //for @required
import 'package:time_tracker_flutter_course/services/auth.dart';

class SignInBloc {
  SignInBloc({@required this.auth});
  final AuthBase auth;

  final StreamController<bool> _isLoadingController = StreamController<bool>();
  Stream<bool> get isLoadingStream => _isLoadingController.stream;

  void dispose() {
    _isLoadingController.close();
  }

  void _setIsLoading(bool isLoading) => _isLoadingController.add(isLoading);

  //above three steps are necessary for every bloc implementation

  Future<User> _signIn(Future<User> Function() signInMethod) async {
    //saving a lot of repetitive code in here
    try {
      _setIsLoading(true);
      return await signInMethod(); //functions as argument to write less code
    } catch (e) {
      _setIsLoading(
          false); //working with streams tricky, don't add values after blocs are disposed
      rethrow;
    }
  }

  Future<User> signInAnonymously() async =>
      await _signIn(auth.signInAnonymously);

  Future<User> signInWithGoogle() async => await _signIn(auth.signInWithGoogle);

  Future<User> signInWithFacebook() async =>
      await _signIn(auth.signInWithFacebook);
}
