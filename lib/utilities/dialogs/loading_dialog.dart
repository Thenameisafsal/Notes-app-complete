import 'package:flutter/material.dart';

typedef CloseDialog = void Function();

CloseDialog showLoadingDialog(
    {required BuildContext context, required String text}) {
  // specify mainaxissize to make sure column doesn't take the entire screen
  final dialog = AlertDialog(
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const CircularProgressIndicator(),
        const SizedBox(
          height: 10.0,
        ),
        Text(text)
      ],
    ),
  );
  // barrier dismissible will specify if the alert dialog can be closed by tapping the screen
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => dialog,
  );

  return () => Navigator.of(context).pop();
}
