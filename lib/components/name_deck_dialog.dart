import 'package:dominion_companion/services/deck_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NameDeckDialog extends StatelessWidget {
  const NameDeckDialog(
      {super.key,
      required this.onSaved,
      this.oldName = "",
      this.oldDescription = ""});

  final void Function(String deckName, String deckDescription) onSaved;
  final String oldName;
  final String oldDescription;

  @override
  Widget build(BuildContext context) {
    final TextEditingController deckNameController =
        TextEditingController(text: oldName);
    final TextEditingController deckDescriptionController =
        TextEditingController(text: oldDescription);
    final deckService = DeckService();

    final scaffoldMessenger = ScaffoldMessenger.of(context);

    return FutureBuilder(
      future: deckService.getAllDeckNames(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child: CircularProgressIndicator()),
            ],
          );
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            throw Exception(snapshot.error);
          } else if (snapshot.hasData) {
            return snapshot.data != null
                ? Scaffold(
                    backgroundColor: Colors.transparent,
                    body: AlertDialog(
                      content: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const SizedBox(
                                height: 10,
                              ),
                              const Text('Deckname'),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 28, vertical: 10),
                                child: TextField(
                                  maxLength: 20,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  keyboardType: TextInputType.text,
                                  controller: deckNameController,
                                  decoration: const InputDecoration(
                                    hintText: 'Name des Decks',
                                  ),
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(RegExp(
                                        r"[\da-zA-ZÀ-ÿ\u1E9E\u00DF -_!?&]")),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text('Deckbeschreibung'),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 28, vertical: 10),
                                child: TextField(
                                  maxLength: 250,
                                  maxLines: 5,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  keyboardType: TextInputType.text,
                                  controller: deckDescriptionController,
                                  decoration: const InputDecoration(
                                    hintText: 'Beschreibung des Decks',
                                  ),
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(RegExp(
                                        r"[\da-zA-ZÀ-ÿ\u1E9E\u00DF -_!?&]")),
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
                                        scaffoldMessenger.showSnackBar(
                                            const SnackBar(
                                                content: Text(
                                                    'Deckname darf nicht leer sein.')));
                                        return;
                                      }
                                      if (deckNameController.text
                                                  .toLowerCase() ==
                                              oldName.toLowerCase() &&
                                          deckDescriptionController.text
                                                  .toLowerCase() ==
                                              oldDescription.toLowerCase()) {
                                        scaffoldMessenger.showSnackBar(
                                            const SnackBar(
                                                content:
                                                    Text('Keine Änderungen.')));
                                        return;
                                      }
                                      if (deckNameController.text
                                              .toLowerCase() ==
                                          "Temporäres Deck".toLowerCase()) {
                                        scaffoldMessenger.showSnackBar(
                                            const SnackBar(
                                                content: Text(
                                                    'Naja ein temoräres Deck ist es nicht. Wähl besser einen anderen Namen.')));
                                        return;
                                      }
                                      if (oldName != deckNameController.text &&
                                          snapshot.data!
                                              .map((e) => e.toLowerCase())
                                              .contains(deckNameController.text
                                                  .toLowerCase())) {
                                        scaffoldMessenger.showSnackBar(
                                            const SnackBar(
                                                content: Text(
                                                    'Es existiert bereits ein Deck mit diesem Namen.')));
                                        return;
                                      }
                                      onSaved(
                                          deckNameController.text.toString(),
                                          deckDescriptionController.text
                                              .toString());
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Speichern'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
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
