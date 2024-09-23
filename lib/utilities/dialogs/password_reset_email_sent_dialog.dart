import 'package:flutter/widgets.dart';
import 'package:notes/utilities/dialogs/generic_error_dialog.dart';

Future<void> showPasswordResetEmailSentDialog(BuildContext context) async {
  await showGenericDialog<void>(
    context: context,
    title: 'Password Reset',
    content:
        'Your Password Reset Email Has been sent, please check your email for details.',
    optionsBuilder: () => {
      "OK": null,
    },
  );
}
