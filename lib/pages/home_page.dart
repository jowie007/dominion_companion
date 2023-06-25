import 'dart:developer' as dev;
import 'dart:math';

import 'package:dominion_comanion/components/card_popup.dart';
import 'package:dominion_comanion/components/custom_alert_dialog.dart';
import 'package:dominion_comanion/components/menu_button.dart';
import 'package:dominion_comanion/services/card_service.dart';
import 'package:dominion_comanion/services/content_service.dart';
import 'package:dominion_comanion/services/end_service.dart';
import 'package:dominion_comanion/services/expansion_service.dart';
import 'package:dominion_comanion/services/hand_service.dart';
import 'package:dominion_comanion/services/music_service.dart';
import 'package:dominion_comanion/services/settings_service.dart';
import 'package:flutter/material.dart';
import 'package:dominion_comanion/router/routes.dart' as route;
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../components/floating_action_button_coin.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _musicService = MusicService();
  CardService cardService = CardService();

  testCardNames() async {
    dev.log("TEST CARD NAMES");
    /*List<Image> columns = [];
      CardService().getAllCards().then((value) => value.forEach((element) {
        columns.add(Image(
          image: AssetImage(
              'assets/cards/full/${element.id.split("-")[0]}/${element.id.split("-")[2]}.png'),
        ));
      }));
      return Column(children: columns);*/
    CardService().getAllCards().then((value) => value.forEach((element) async {
          var split = element.id.split("-");
          if (split[1] != "set") {
            try {
              await rootBundle
                  .load('assets/cards/full/${split[0]}/${split[2]}.png');
            } catch (_) {
              dev.log("${element.id} not found");
            }
          }
        }));
  }

  @override
  Widget build(BuildContext context) {
    /* TODO Auslagern in main.dart und anpassen, dass nur neu intialisiert wird, wenn sich die DB Version geändert hat*/
    // ExpansionService().loadJsonExpansionsIntoDB();
    PackageInfo.fromPlatform()
        .then((packageInfo) => {dev.log("INIT DB " + packageInfo.version)});
    ExpansionService()
        .deleteExpansionTable()
        .then((value) => CardService().deleteCardTable())
        .then((value) => ContentService().deleteContentTable())
        .then((value) => HandService().deleteHandTable())
        .then((value) => EndService().deleteEndTable())
        .then((value) => ExpansionService().loadJsonExpansionsIntoDB())
        .then((value) => ExpansionService()
            .loadAllExpansions()
            .then((value) => dev.log("ALL EXPANSIONS LOADED")))
        .then((_) => testCardNames());

    SettingsService()
        .deleteSettingsTable()
        .then((value) => SettingsService().initSettings())
        .then((value) => SettingsService().loadSettings())
        .then((value) => dev.log("ALL SETTINGS LOADED"));

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
                padding: const EdgeInsets.fromLTRB(0, 40, 0, 40),
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
                              future: cardService.getCardOfTheDay(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData && snapshot.data != null) {
                                  return CardPopup(
                                      cardIds: snapshot.data!.values.first,
                                      expansionId: snapshot.data!.keys.first
                                          .getExpansionId());
                                } else {
                                  return const CustomAlertDialog(
                                    title: "Fehler",
                                    message: "Karte konnte nicht geladen werden",
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
