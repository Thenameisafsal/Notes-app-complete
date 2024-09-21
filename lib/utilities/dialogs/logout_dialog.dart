import 'package:flutter/material.dart';
import 'package:notes/utilities/dialogs/generic_error_dialog.dart';

Future<bool> showErrorDialog(BuildContext context) {
  return showGenericDialog(
      context: context,
      title: "Log Out",
      content: "Are you sure you want to logout?",
      optionsBuilder: () => {
            "cancel": false,
            "log out": true,
          }).then((value) => value ?? false); // handle the case where user gives no input
}
