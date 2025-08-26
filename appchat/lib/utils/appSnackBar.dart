import 'package:flutter/material.dart';

class AppSnackBar {
  static void showSnackBar(context, String message, int duration) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: duration),
      ),
    );
  }
}
