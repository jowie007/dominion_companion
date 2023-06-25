import 'dart:convert';
import 'dart:developer';

import 'package:dominion_comanion/components/basic_appbar.dart';
import 'package:dominion_comanion/components/custom_alert_dialog.dart';
import 'package:dominion_comanion/components/error_dialog.dart';
import 'package:dominion_comanion/services/deck_service.dart';
import 'package:dominion_comanion/services/file_service.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _DeckInfoState();
}

class _DeckInfoState extends State<SettingsPage> {
  @override
  initState() {
    super.initState();
  }

  void onLoadDeck() async {
    final dbDecks = await DeckService().pickDeckJSONFile();
    if (dbDecks == null && context.mounted) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const ErrorDialog(
              title: "Fehler", message: "Decks konnten nicht geladen werden");
        },
      );
    } else {
      final deckNames = await DeckService().getAllDeckNames();
      log(dbDecks.toString());
      dbDecks!.map(
        (deck) async => {
          log("YES"),
          if (deckNames.contains(deck.name)) {
            await showDialog(
              context: context,
              builder: (BuildContext context) {
                return CustomAlertDialog(
                  title: "Doppeltes Deck",
                  message:
                      "Ein Deck, welches importiert wird, trägt den gleichen Namen, wie ein bereits existierendes Deck. Möchtest du das existierende Deck überschreiben?",
                  cancelText: "Überspringen",
                  confirmText: "Überschreiben",
                  onConfirm: () => DeckService().importDeck(deck),
                );
              },
            ),
          } else {
            DeckService().importDeck(deck),
          }
        },
      ).toList();
    }
  }

  // https://www.woolha.com/tutorials/flutter-using-futurebuilder-widget-examples
  @override
  Widget build(BuildContext context) {
    final cachedContext = context;
    return Scaffold(
      appBar: const BasicAppBar(title: 'Einstellungen'),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/menu/main_scroll_crop.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                child: Column(children: [
                  const Text(
                    "Backups:",
                    style: TextStyle(
                        fontSize: 20, decoration: TextDecoration.underline),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      FileService().shareTemporaryJSONFile("decks",
                          jsonEncode(await DeckService().getDBDeckList()));
                      // Share.shareXFiles(['${directory.path}/image.jpg'], text: 'Great picture');
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white),
                    child: const Text("Decks speichern"),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      onLoadDeck();
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white),
                    child: const Text("Decks laden"),
                  ),
                ]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
