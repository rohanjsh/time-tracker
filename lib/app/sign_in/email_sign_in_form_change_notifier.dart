import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app/sign_in/email_sign_in_change_model.dart';
import 'package:time_tracker_flutter_course/common_widgets/form_submit_button.dart';
import 'package:time_tracker_flutter_course/common_widgets/show_exception_alert_dialog.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

//email password to bloc
//BLOC + custom model class
//Below is basic bloc pattern implementation for most of the cases
//EmailSignInModel -> EmailSignInBloc -> Bloc will manage a Stream<EmailSignInModel> -> Form will rebuild via StreamBuilder<EmailSignInModel> -> form callbacks will update the model via the bloc.
//refactoring widget is complex
class EmailSignInFormChangeNotifier extends StatefulWidget {
  //cannot convert to stateless widget because of TextEditing controllers holds state
  //mixins introduction
  EmailSignInFormChangeNotifier({@required this.model});
  final EmailSignInChangeModel model;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return ChangeNotifierProvider<EmailSignInChangeModel>(
      create: (_) => EmailSignInChangeModel(auth: auth),
      child: Consumer<EmailSignInChangeModel>(
        builder: (_, bloc, __) => EmailSignInFormChangeNotifier(model: bloc),
      ),
    );
  }

  @override
  _EmailSignInFormChangeNotifierState createState() =>
      _EmailSignInFormChangeNotifierState();
}

class _EmailSignInFormChangeNotifierState
    extends State<EmailSignInFormChangeNotifier> {
  final TextEditingController _emailController =
      TextEditingController(); //text editing controller works only with stateful widgets

  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  EmailSignInChangeModel get model => widget.model;

  void _emailEditingComplete() {
    final newFocus = model.emailValidator.isValid(model.email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context)
        .requestFocus(newFocus); //usedto get next field for input
  }

  Future<void> _submit() async {
    try {
      //future.delayed for artificial slow network
      await model.submit();
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      //catching auth exceptions
      showExceptionAlertDialog(
        context,
        title: 'Sign in failed',
        exception: e,
      );
    }
  }

  void _toggleFormType() {
    model.toggleFormType();
    _emailController.clear(); //stays in sync with the bloc
    _passwordController.clear();
  }

  List<Widget> _buildChildren() {
    return [
      _buildEmailTextField(),
      SizedBox(
        height: 8.0,
      ),
      _buildPasswordTextField(),
      SizedBox(
        height: 8.0,
      ),
      FormSubmitButton(
        text: model.primaryButtonText,
        onPressed: model.canSubmit ? _submit : null,
      ),
      SizedBox(
        height: 8.0,
      ),
      TextButton(
        onPressed: !model.isLoading ? _toggleFormType : null,
        child: Text(model.secondaryButtonText),
      ),
    ];
  }

  TextField _buildPasswordTextField() {
    return TextField(
      textInputAction: TextInputAction.done,
      focusNode: _passwordFocusNode,
      autocorrect: false,
      controller: _passwordController,
      obscureText: true,
      onEditingComplete: _submit,
      onChanged: model.updatePassword, //implicit parameter passing
      decoration: InputDecoration(
        enabled: model.isLoading == false,
        labelText: 'Password',
        errorText: model.passwordErrorText,
      ),
    );
  }

  TextField _buildEmailTextField() {
    return TextField(
      controller: _emailController,
      focusNode: _emailFocusNode,
      textInputAction: TextInputAction.next,
      autocorrect: false,
      onEditingComplete: () => _emailEditingComplete(),
      onChanged: model.updateEmail, //implicit parameter passing
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        enabled: model.isLoading == false,
        labelText: 'Email',
        hintText: 'test@test.com',
        errorText: model.emailErrorText,
      ),
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
}
