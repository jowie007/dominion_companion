import 'dart:convert';

import 'package:dominion_companion/components/basic_appbar.dart';
import 'package:dominion_companion/components/custom_alert_dialog.dart';
import 'package:dominion_companion/components/error_dialog.dart';
import 'package:dominion_companion/database/model/deck/deck_db_model.dart';
import 'package:dominion_companion/services/deck_service.dart';
import 'package:dominion_companion/services/file_service.dart';
import 'package:dominion_companion/services/settings_service.dart';
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
  final _settingsService = SettingsService();

  void onLoadDeck() async {
    final importedDecks = await DeckService().pickDeckJSONFile();
    if (importedDecks == null && context.mounted) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const ErrorDialog(
              title: "Fehler", message: "Decks konnten nicht geladen werden");
        },
      );
    } else {
      final dbDecks = await DeckService().getDBDeckList();
      for (var importedDeck in importedDecks!) {
        int? existingId;
        int? newId;
        for (var dbDeck in dbDecks) {
          if (dbDeck.name.toLowerCase() == importedDeck.name.toLowerCase()) {
            existingId = dbDeck.id;
            break;
          }
        }
        if (existingId != null && context.mounted) {
          await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return CustomAlertDialog(
                title: "Doppeltes Deck",
                message:
                    "Ein Deck mit dem Namen ${importedDeck.name} exisitert bereits. Möchtest du das existierende Deck überschreiben?",
                cancelText: "Überspringen",
                confirmText: "Überschreiben",
                onConfirm: () async => {
                  await _deckService.removeCachedImage(existingId!),
                  newId = await DeckService()
                      .importDeck(importedDeck, deleteId: existingId),
                  await _deckService.setCachedImage(newId!, importedDeck.image),
                },
              );
            },
          );
        } else if (context.mounted) {
          newId = await DeckService().importDeck(importedDeck);
          await _deckService.setCachedImage(newId, importedDeck.image);
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
                fit: BoxFit.fill,
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
                      var withImages = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const CustomAlertDialog(
                            title: "Decks exportieren",
                            message:
                                "Möchtest du die Decks mit oder ohne Bilder exportieren? Falls du dich für die Option mit Bildern entscheidest kann die Datei sehr groß werden und es kann eventuell zu Problemen beim Import kommen.",
                            cancelText: "Ohne",
                            confirmText: "Mit",
                          );
                        },
                      );
                      if (withImages != null) {
                        List<DeckDBModel> deckDBList;
                        if (withImages) {
                          deckDBList =
                              await DeckService().getDBDeckListWithImages();
                        } else {
                          deckDBList = await DeckService().getDBDeckList();
                        }
                        var jsonFile = jsonEncode(deckDBList);
                        FileService().shareTemporaryJSONFile("decks", jsonFile);
                        // Share.shareXFiles(['${directory.path}/image.jpg'], text: 'Great picture');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white),
                    child: const Text("Decks exportieren"),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      onLoadDeck();
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white),
                    child: const Text("Decks importieren"),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Audio:",
                    style: TextStyle(
                        fontSize: 20, decoration: TextDecoration.underline),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 44, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Checkbox(
                          value: _settingsService.getCachedSettings().playAudio,
                          onChanged: (bool? value) {
                            _settingsService
                                .setCachedSettingsPlayAudio(value ?? false);
                            setState(() {});
                          },
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Audioeffekte",
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Version:",
                    style: TextStyle(
                        fontSize: 20, decoration: TextDecoration.underline),
                  ),
                  Text(
                    _settingsService.getCachedSettings().version,
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
