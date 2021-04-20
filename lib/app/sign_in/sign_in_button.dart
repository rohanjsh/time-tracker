import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/common_widgets/custom_raised_button.dart';

class SignInButton extends CustomRaisedButton {
  //inheritance

  SignInButton({
    @required String text,
    Color color,
    Color textColor,
    VoidCallback onPressed,
  })  : assert(text != null), //correct error detection
        super(
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 16.0,
            ),
          ),
          color: color,
          onPressed: onPressed,
        );
}
