import 'package:flutter/material.dart';

void showToast(BuildContext context, String msg, String type) {
  final scaffold = ScaffoldMessenger.of(context);

  var color = Colors.blue;

  switch (type) {
    case "error":
      color = Colors.red;
      break;
    case "success":
      color = Colors.green;
      break;
    case "info":
      color = Colors.blue;
      break;
    case "warning":
      color = Colors.orange;
      break;
    default:
  }

  scaffold.showSnackBar(
    SnackBar(
      content: Text(msg),
      backgroundColor: color,
    ),
  );
}
