import 'dart:developer' as dev;
import 'dart:math';

import 'package:dominion_companion/components/card_popup.dart';
import 'package:dominion_companion/components/custom_alert_dialog.dart';
import 'package:dominion_companion/components/error_dialog.dart';
import 'package:dominion_companion/components/menu_button.dart';
import 'package:dominion_companion/services/card_service.dart';
import 'package:dominion_companion/services/music_service.dart';
import 'package:dominion_companion/services/settings_service.dart';
import 'package:flutter/material.dart';
import 'package:dominion_companion/router/routes.dart' as route;

import '../components/floating_action_button_coin.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _musicService = MusicService();
  final _cardService = CardService();
  final _settingsService = SettingsService();

  @override
  Widget build(BuildContext context) {
    final boxartList = [
      "adventures.webp",
      "allies.jpg",
      "base.webp",
      "cornucopia.jpg",
      "empires.jpg",
      "hinterlands.jpg",
      "hinterlands2.jpg",
      "nocturne.jpg",
      "prosperity.jpg",
      "seaside.jpg",
      "seaside2.jpg"
    ];

    if (_settingsService.initException != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return ErrorDialog(
              title: "Fehler",
              message: _settingsService.initException.toString());
        },
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    "assets/artwork/background/${boxartList[Random().nextInt(boxartList.length)]}"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          /*const Align(
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              child: Image(
                image: AssetImage('assets/menu/spear-left.png'),
              ),
            ),
          ),
          const Align(
            alignment: Alignment.centerRight,
            child: FractionallySizedBox(
              child: Image(
                image: AssetImage('assets/menu/spear-right.png'),
              ),
            ),
          ),*/
          SingleChildScrollView(
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                padding: const EdgeInsets.fromLTRB(0, 60, 0, 40),
                child: Column(children: [
                  const SizedBox(
                    height: 140,
                    child: Image(
                      image: AssetImage('assets/menu/jdc.png'),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  MenuButton(
                      text: "Neu",
                      callback: () {
                        Navigator.pushNamed(context, route.createDeckPage);
                      }),
                  const SizedBox(height: 10),
                  MenuButton(
                      text: "Decks",
                      callback: () {
                        Navigator.pushNamed(context, route.deckPage);
                      }),
                  const SizedBox(height: 10),
                  MenuButton(
                      text: "Tageskarte",
                      callback: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return FutureBuilder(
                              future: _cardService.getCardOfTheDay(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData && snapshot.data != null) {
                                  return CardPopup(
                                      cardIds: snapshot.data!.values.first,
                                      expansionId: snapshot.data!.keys.first
                                          .getExpansionId());
                                } else {
                                  return const CustomAlertDialog(
                                    title: "Fehler",
                                    message:
                                        "Karte konnte nicht geladen werden",
                                    onlyCancelButton: true,
                                  );
                                }
                              },
                            );
                          },
                        );
                      }),
                  const SizedBox(height: 10),
                  MenuButton(
                      text: "Einstellungen",
                      callback: () {
                        Navigator.pushNamed(context, route.settingsPage);
                      }),
                ]),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: ValueListenableBuilder(
        valueListenable: _musicService.notifier,
        builder: (BuildContext context, bool val, Widget? child) {
          return FloatingActionButtonCoin(
            icon: _musicService.isPlaying ? Icons.music_note : Icons.music_off,
            tooltip: _musicService.getTooltip(),
            onPressed: () => _musicService.togglePlaying(),
          );
        },
      ),
    );
  }
}
