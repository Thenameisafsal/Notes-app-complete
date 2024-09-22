import 'package:flutter/material.dart';
import 'package:notes/utilities/dialogs/generic_error_dialog.dart';

Future<void> cannotShareEmptyNoteDialog(BuildContext context) {
  return showGenericDialog<void>(
    context: context,
    title: 'Share Error',
    content: 'You cannot share empty notes!',
    optionsBuilder: () => {
      "OK": null,
    }, // this will specify the options available in the dialog -> optionsBuilder returns a map of options
  );
}
