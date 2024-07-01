import 'package:dominion_companion/components/card_popup.dart';
import 'package:dominion_companion/components/error_dialog.dart';
import 'package:dominion_companion/components/menu_button.dart';
import 'package:dominion_companion/model/card/card_model.dart';
import 'package:dominion_companion/router/routes.dart' as route;
import 'package:dominion_companion/services/card_service.dart';
import 'package:dominion_companion/services/file_service.dart';
import 'package:dominion_companion/services/music_service.dart';
import 'package:dominion_companion/services/settings_service.dart';
import 'package:flutter/material.dart';

import '../components/floating_action_button_coin.dart';
import '../services/expansion_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _musicService = MusicService();
  final _cardService = CardService();
  final _settingsService = SettingsService();
  final _fileService = FileService();
  final _expansionService = ExpansionService();
  bool isLoadingCardOfTheDay = true;
  List<String> cardOfTheDayIds = [];
  String cardOfTheDayExpansionId = '';
  String cardOfTheDayExpansionName = '';

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
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
      initCardOfTheDay();
    });
  }

  void initCardOfTheDay() async {
    Map<CardModel, List<String>>? cardOfTheDayInfo =
        await _cardService.getCardOfTheDay();
    if (cardOfTheDayInfo != null) {
      cardOfTheDayIds =
          (await _cardService.getCardIdsForPopup(cardOfTheDayInfo.keys.first));
      cardOfTheDayExpansionId = cardOfTheDayIds.first.split("-")[0];
      cardOfTheDayExpansionName = await _expansionService
          .getExpansionNameByCardId(cardOfTheDayExpansionId);
    }
    setState(() {
      isLoadingCardOfTheDay = false;
    });
  }

  void checkForUpdates(BuildContext context) async {
    if (await _settingsService.checkForUpdates() == true) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Neue Updates sind verfügbar. Gehe zu Einstellungen zum Herunterladen.')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    checkForUpdates(context);
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(_fileService.backgroundImagePath!),
                alignment: _fileService.boxArtAlignment,
                fit: BoxFit.cover,
              ),
            ),
          ),
          /* const Align(
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
          ), */
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
                            return isLoadingCardOfTheDay
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : CardPopup(
                                    cardIds: cardOfTheDayIds,
                                    expansionId: cardOfTheDayExpansionId,
                                    expansionName: cardOfTheDayExpansionName,
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
