import 'dart:convert';
import 'dart:developer';

import 'package:dominion_companion/components/basic_appbar.dart';
import 'package:dominion_companion/components/custom_alert_dialog.dart';
import 'package:dominion_companion/components/error_dialog.dart';
import 'package:dominion_companion/services/deck_service.dart';
import 'package:dominion_companion/services/file_service.dart';
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

  final _deckService = DeckService();

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
      for (var deck in dbDecks!) {
        if (deckNames.contains(deck.name) && context.mounted) {
          await showDialog(
            context: context,
            builder: (BuildContext context) {
              return CustomAlertDialog(
                title: "Doppeltes Deck",
                message:
                    "Ein Deck mit dem Namen ${deck.name} exisitert bereits. Möchtest du das existierende Deck überschreiben?",
                cancelText: "Überspringen",
                confirmText: "Überschreiben",
                onConfirm: () => {
                  _deckService.removeCachedImage(deck.name),
                  DeckService().importDeck(deck)
                },
              );
            },
          );
        } else if (context.mounted) {
          _deckService.removeCachedImage(deck.name);
          DeckService().importDeck(deck);
        }
      }
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Decks wurden importiert.')));
      }
    }
  }

  // https://www.woolha.com/tutorials/flutter-using-futurebuilder-widget-examples
  @override
  Widget build(BuildContext context) {
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
