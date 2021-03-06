import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app/sign_in/email_sign_in_model.dart';
import 'package:time_tracker_flutter_course/app/sign_in/validators.dart';
import 'package:time_tracker_flutter_course/common_widgets/form_submit_button.dart';
import 'package:time_tracker_flutter_course/common_widgets/show_exception_alert_dialog.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

//email password to bloc
//BLOC + custom model class
//Below is basic bloc pattern implementation for most of the cases
//EmailSignInModel -> EmailSignInBloc -> Bloc will manage a Stream<EmailSignInModel> -> Form will rebuild via StreamBuilder<EmailSignInModel> -> form callbacks will update the model via the bloc.
//refactoring widget is complex
class EmailSignInFormStateful extends StatefulWidget
    with EmailAndPasswordValidators {
  //mixins introduction
  EmailSignInFormStateful({Key key, this.onSignedIn});
  final VoidCallback onSignedIn;

  @override
  _EmailSignInFormStatefulState createState() =>
      _EmailSignInFormStatefulState();
}

class _EmailSignInFormStatefulState extends State<EmailSignInFormStateful> {
  final TextEditingController _emailController =
      TextEditingController(); //text editing controller works only with stateful widgets

  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  String get _email => _emailController.text;
  String get _password => _passwordController.text;

  EmailSignInFormType _formtype = EmailSignInFormType.signIn;
  bool _submitted = false;
  bool _isLoading = false;

  void _emailEditingComplete() {
    final newFocus = widget.emailValidator.isValid(_email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context)
        .requestFocus(newFocus); //usedto get next field for input
  }

  Future<void> _submit() async {
    setState(() {
      _submitted = true;
      _isLoading = true;
    });
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      //future.delayed for artificial slow network
      if (_formtype == EmailSignInFormType.signIn) {
        await auth.signInWithEmailAndPassword(_email, _password);
      } else {
        await auth.createUserWithEmailAndPassword(_email, _password);
      }
      if (widget.onSignedIn != null) {
        //added while testing
        widget.onSignedIn();
      }
    } on FirebaseAuthException catch (e) {
      //catching auth exceptions
      showExceptionAlertDialog(
        context,
        title: 'Sign in failed',
        exception: e,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _toggleFormType() {
    setState(() {
      _submitted = false; //resetting complete
      _formtype = _formtype == EmailSignInFormType.signIn
          ? EmailSignInFormType.register
          : EmailSignInFormType.signIn;
    });
    _emailController.clear();
    _passwordController.clear();
  }

  List<Widget> _buildChildren() {
    final primaryText = _formtype == EmailSignInFormType.signIn
        ? 'Sign In'
        : 'Create an Account';
    final secondaryText = _formtype == EmailSignInFormType.signIn
        ? 'Need an account? Register'
        : 'Have an account? Sign in';

    bool submitEnabled = widget.emailValidator.isValid(_email) &&
        widget.passwordValidator.isValid(_password) &&
        _isLoading;
    return [
      buildEmailTextField(),
      SizedBox(
        height: 8.0,
      ),
      buildPasswordTextField(),
      SizedBox(
        height: 8.0,
      ),
      FormSubmitButton(
        text: primaryText,
        onPressed: submitEnabled ? _submit : null,
      ),
      SizedBox(
        height: 8.0,
      ),
      TextButton(
        onPressed: !_isLoading ? _toggleFormType : null,
        child: Text(secondaryText),
      ),
    ];
  }

  TextField buildPasswordTextField() {
    bool showErrorText =
        _submitted && !widget.passwordValidator.isValid(_password);
    return TextField(
      key: Key('password'), //added while testing
      textInputAction: TextInputAction.done,
      focusNode: _passwordFocusNode,
      autocorrect: false,
      controller: _passwordController,
      obscureText: true,
      onEditingComplete: _submit,
      onChanged: (password) => _updateState(),
      decoration: InputDecoration(
          enabled: _isLoading == false,
          labelText: 'Password',
          errorText: showErrorText ? widget.errorPasswordText : null),
    );
  }

  TextField buildEmailTextField() {
    bool showErrorText = _submitted && !widget.emailValidator.isValid(_email);
    return TextField(
      key: Key('email'), //added while testing
      controller: _emailController,
      focusNode: _emailFocusNode,
      textInputAction: TextInputAction.next,
      autocorrect: false,
      onEditingComplete: _emailEditingComplete,
      onChanged: (email) => _updateState(),
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
          enabled: _isLoading == false,
          labelText: 'Email',
          hintText: 'test@test.com',
          errorText: showErrorText ? widget.errorEmailText : null),
    );
  }

  @override
  void dispose() {
    //JUST DO IT
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch, //all widget strech
        mainAxisSize: MainAxisSize.min, //fit content as needed not full screen
        children: _buildChildren(),
      ),
    );
  }

  void _updateState() {
    setState(() {});
  }
}
