import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showToast({required String message, required ToastStates state}) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: getColor(state),
      textColor: Colors.white,
      fontSize: 16.0);
}

enum ToastStates { error, success, warning }

Color getColor(ToastStates state) {
  switch (state) {
    case ToastStates.success:
      return Colors.blueGrey[900]!.withOpacity(0.7);
    case ToastStates.error:
      return Colors.red;
    case ToastStates.warning:
      return Colors.yellow;
  }
}
