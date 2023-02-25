import 'dart:math';

import 'package:dominion_comanion/components/menu_button.dart';
import 'package:dominion_comanion/services/card_service.dart';
import 'package:dominion_comanion/services/deck_service.dart';
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
    ExpansionService().deleteExpansionTable().then((value) => CardService()
        .deleteCardTable()
        .then((value) => ExpansionService().loadJsonExpansionsIntoDB()));

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
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              padding: const EdgeInsets.fromLTRB(0, 28, 0, 0),
              child: const SizedBox(
                height: 140,
                child: Image(
                  image: AssetImage('assets/menu/jdc.png'),
                ),
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
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              padding: const EdgeInsets.fromLTRB(0, 200, 0, 0),
              child: Column(children: [
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
    // Center is a layout widget. It takes a single child and positions it
    // in the middle of the parent.
    /*child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods. */
  }
}
