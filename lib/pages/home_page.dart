import 'dart:developer' as dev;
import 'dart:math';

import 'package:dominion_comanion/components/menu_button.dart';
import 'package:dominion_comanion/services/expansion_service.dart';
import 'package:dominion_comanion/services/music_service.dart';
import 'package:flutter/material.dart';
import 'package:dominion_comanion/router/routes.dart' as route;

import '../components/floating_action_button_coin.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _musicService = MusicService();

  @override
  Widget build(BuildContext context) {
    /* TODO Auslagern in main.dart und anpassen, dass nur neu intialisiert wird, wenn sich die DB Version geändert hat*/
    ExpansionService().loadJsonExpansionsIntoDB();
    /*ExpansionService()
        .deleteExpansionTable()
        .then((value) => CardService().deleteCardTable())
        .then((value) => ContentService().deleteContentTable())
        .then((value) => ExpansionService().loadJsonExpansionsIntoDB())
        .then((value) => ExpansionService()
            .loadAllExpansions()
            .then((value) => dev.log(value.first.name)));*/

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

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
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
          const Align(
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
          ),
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
                      text: "Decks",
                      callback: () {
                        Navigator.pushNamed(context, route.deckPage);
                      }),
                  const SizedBox(height: 10),
                  MenuButton(
                      text: "Cards",
                      callback: () {
                        Navigator.pushNamed(context, route.deckPage);
                      }),
                  const SizedBox(height: 10),
                  MenuButton(
                      text: "Settings",
                      callback: () {
                        Navigator.pushNamed(context, route.deckPage);
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
