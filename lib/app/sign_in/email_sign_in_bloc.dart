import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/cupertino.dart';
import 'package:time_tracker_flutter_course/app/sign_in/email_sign_in_model.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

//behaviour subject
class EmailSignInBloc {
  EmailSignInBloc({@required this.auth});
  final AuthBase auth;

  final _modelSubject =
      BehaviorSubject<EmailSignInModel>.seeded(EmailSignInModel()); //rxDART

  Stream<EmailSignInModel> get modelStream => _modelSubject.stream;
  EmailSignInModel get _model => _modelSubject.value;

  void dispose() {
    _modelSubject.close();
  }

  Future<void> submit() async {
    updateWidth(submitted: true, isLoading: true);
    try {
      //future.delayed for artificial slow network
      if (_model.formType == EmailSignInFormType.signIn) {
        await auth.signInWithEmailAndPassword(_model.email, _model.password);
      } else {
        await auth.createUserWithEmailAndPassword(
            _model.email, _model.password);
      }
    } catch (e) {
      //catching auth exceptions
      updateWidth(isLoading: false); //moved from finally
      rethrow;
    }
  }

//methods
  void toggleFormType() {
    final formType = _model.formType == EmailSignInFormType.signIn
        ? EmailSignInFormType.register
        : EmailSignInFormType.signIn;
    updateWidth(
      email: '',
      password: '',
      formType: formType,
      submitted: false,
      isLoading: false,
    );
  }

  void updateEmail(String email) => updateWidth(email: email);
  void updatePassword(String password) => updateWidth(password: password);

  void updateWidth(
      {String email,
      String password,
      EmailSignInFormType formType,
      bool isLoading,
      bool submitted}) {
    //update model , add updated model to _model controller
    _modelSubject.value = _model.copyWith(
      email: email,
      password: password,
      formType: formType,
      isLoading: isLoading,
      submitted: submitted,
    );
  }
}
