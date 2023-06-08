import 'dart:developer';

import 'package:dominion_comanion/services/deck_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NameDeckDialog extends StatelessWidget {
  const NameDeckDialog(
      {super.key,
      required this.onSaved,
      this.oldName = ""});

  final void Function(String deckName) onSaved;
  final String oldName;

  @override
  Widget build(BuildContext context) {
    final TextEditingController deckNameController =
        TextEditingController(text: oldName);
    final deckService = DeckService();

    final scaffoldMessenger = ScaffoldMessenger.of(context);

    // TODO Snackbar in der Ebene über dem Dialog anzeigen
    return FutureBuilder(
      future: deckService.getAllDeckNames(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CircularProgressIndicator(),
            ],
          );
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            throw Exception(snapshot.error);
          } else if (snapshot.hasData) {
            return snapshot.data != null
                ? Dialog(
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
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 10),
                            child: TextField(
                              controller: deckNameController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Name des Decks',
                              ),
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(
                                    RegExp(r"[\da-zA-ZÀ-ÿ\u1E9E\u00DF -_!?&]")),
                              ],
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
                                  if (deckNameController.text == "") {
                                    scaffoldMessenger.showSnackBar(const SnackBar(
                                        content: Text(
                                            'Deckname darf nicht leer sein.')));
                                    return;
                                  }
                                  if (deckNameController.text.toLowerCase() ==
                                      oldName.toLowerCase()) {
                                    scaffoldMessenger.showSnackBar(const SnackBar(
                                        content: Text(
                                            'Deckname ist der gleiche wie zuvor.')));
                                    return;
                                  }
                                  if (deckNameController.text.toLowerCase() ==
                                      "Temporäres Deck".toLowerCase()) {
                                    scaffoldMessenger.showSnackBar(const SnackBar(
                                        content: Text(
                                            'Ne, du speicherst es ja, es ist dann kein temporäres Deck mehr.')));
                                    return;
                                  }
                                  if (snapshot.data!
                                      .map((e) => e.toLowerCase())
                                      .contains(deckNameController.text
                                          .toLowerCase())) {
                                    scaffoldMessenger.showSnackBar(const SnackBar(
                                        content: Text(
                                            'Es existiert bereits ein Deck mit diesem Namen.')));
                                    return;
                                  }
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
                  )
                : const Text('Deck kann momentan nicht umbenannt werden');
          } else {
            return const Text('Deck kann momentan nicht umbenannt werden');
          }
        } else {
          return Text('State: ${snapshot.connectionState}');
        }
      },
    );
  }
}
