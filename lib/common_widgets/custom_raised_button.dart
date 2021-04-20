import 'package:flutter/material.dart';

class CustomRaisedButton extends StatelessWidget {
  CustomRaisedButton({
    //constructor definition
    this.borderRadius: 2.0, //defining default values
    this.child,
    this.color,
    this.onPressed,
    this.height: 50.0,
  }) : assert(borderRadius != null);

  final Widget child;
  final Color color;
  final double borderRadius;
  final double height;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ElevatedButton(
        //alternative for raised button migrated
        child: child,
        style: ButtonStyle(
          //background color different implementation
          backgroundColor: MaterialStateColor.resolveWith((states) => color),
          shape: MaterialStateProperty.resolveWith(//shape property
              (states) => RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                    Radius.circular(borderRadius),
                  ))),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
