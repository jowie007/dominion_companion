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
                  await DeckService()
                      .importDeck(importedDeck, deleteId: existingId),
                },
              );
            },
          );
        } else if (context.mounted) {
          await DeckService().importDeck(importedDeck);
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
                      List<DeckDBModel> deckDBList;
                      deckDBList = await DeckService().getDBDeckList();
                      var jsonFile = jsonEncode(deckDBList);
                      FileService().shareTemporaryJSONFile("decks", jsonFile);
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
                    "Kartenansicht:",
                    style: TextStyle(
                        fontSize: 20, decoration: TextDecoration.underline),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 44, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Checkbox(
                          value: _settingsService
                              .getCachedSettings()
                              .gyroscopeCardPopup,
                          onChanged: (bool? value) {
                            _settingsService
                                .setCachedSettingsGyroscopeCardPopup(
                                    value ?? false);
                            setState(() {});
                          },
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Gyroscope",
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
                  const SizedBox(height: 20),
                  const Text(
                    "Lizenzen:",
                    style: TextStyle(
                        fontSize: 20, decoration: TextDecoration.underline),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white),
                    onPressed: () {
                      showLicensePage(
                        context: context,
                        applicationIcon: SizedBox(
                          height: 200, // Set the height as needed
                          child: Image.asset("assets/logo/logo_white.png"),
                        ),
                      );
                    },
                    child: const Text('Lizenzen anzeigen'),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                        "Ein Großteil der genutzten Inhalte wurde von www.dominion-welt.de, www.dominion.games, sowie dem Videospiel (store.steampowered.com/app/1131620/Dominion/) übernommen. Etwaige Rechte liegen nicht bei mir. Diese App wird kostenlos zur Verfügung gestellt und soll eine Unterstützung bei der Erstellung von Kartendecks des Spiels 'Dominion' bieten. Sollte es dennoch Probleme bezüglich der Bereitsstellung geben, bitte ich um eine kurze Nachricht."),
                  )
                ]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
