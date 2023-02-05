import 'package:flutter/material.dart';

class NameDeckDialog extends StatelessWidget {
  const NameDeckDialog({super.key, required this.onSaved});

  final void Function(String deckName) onSaved;

  @override
  Widget build(BuildContext context) {
    final TextEditingController deckNameController = TextEditingController();
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(
              height: 10,
            ),
            const Text('Deck speichern'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              child: TextField(
                controller: deckNameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Name des Decks',
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Abbrechen'),
                ),
                TextButton(
                  onPressed: () {
                    onSaved(deckNameController.text);
                    Navigator.pop(context);
                  },
                  child: const Text('Speichern'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
