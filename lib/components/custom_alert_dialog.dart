import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  const CustomAlertDialog(
      {super.key,
      required this.title,
      required this.message,
      this.onlyCancelButton = false,
        this.onConfirm,
      this.onCancel,
      this.confirmText = "Ja",
      this.cancelText = "Abbrechen"});

  final String title;
  final String message;
  final bool onlyCancelButton;
  final String confirmText;
  final String cancelText;
  final void Function()? onConfirm;
  final void Function()? onCancel;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(message),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(cancelText),
          onPressed: () {
            Navigator.pop(context, false);
            onCancel != null ? onCancel!() : "";
          },
        ),
        !onlyCancelButton
            ? TextButton(
                child: Text(confirmText),
                onPressed: () {
                  Navigator.pop(context, true);
                  onConfirm != null ? onConfirm!() : "";
                },
              )
            : Container(),
      ],
    );
  }
}
