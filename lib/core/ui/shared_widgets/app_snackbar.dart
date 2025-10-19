import 'package:flutter/material.dart';

void showSnackBar(
  BuildContext context, {
  required dynamic message,
  Color? color,
  Widget? action,
  EdgeInsetsGeometry? margin = const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 32.0),
}) {
  final scaffoldMessenger = ScaffoldMessenger.maybeOf(context);
  if (scaffoldMessenger == null) return;

  scaffoldMessenger.clearSnackBars();

  message = message.toString();

  const snackBarDuration = Duration(seconds: 4);

  final snackBar = SnackBar(
    duration: snackBarDuration,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
    margin: margin,
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: color ?? Colors.red,
    content: Directionality(
      textDirection:
        
          TextDirection.ltr,
      
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              (message as String),
              style: TextStyle(color: Colors.white),
            ),
          ),
          if (action != null) action,
        ],
      ),
    ),
  );

  scaffoldMessenger.showSnackBar(snackBar);
}
