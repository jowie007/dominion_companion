import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  const CustomAlertDialog(
      {super.key,
      required this.title,
      required this.message,
      this.onlyCancelButton = false,
      this.onConfirm});

  final String title;
  final String message;
  final bool onlyCancelButton;
  final void Function()? onConfirm;

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
          child: const Text('Abbrechen'),
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
        !onlyCancelButton
            ? TextButton(
                child: const Text('Ja'),
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
