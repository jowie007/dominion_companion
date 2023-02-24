import 'package:dominion_comanion/components/basic_appbar.dart';
import 'package:dominion_comanion/components/basic_infobar_bottom.dart';
import 'package:dominion_comanion/components/button_player_count.dart';
import 'package:dominion_comanion/components/button_plus_minus.dart';
import 'package:dominion_comanion/components/deck_expandable_loader.dart';
import 'package:dominion_comanion/components/delete_deck_dialog.dart';
import 'package:dominion_comanion/components/floating_action_button_coin.dart';
import 'package:dominion_comanion/database/model/deck/deck_db_model.dart';
import 'package:dominion_comanion/services/deck_service.dart';
import 'package:dominion_comanion/router/routes.dart' as route;
import 'package:flutter/material.dart';

class DeckPage extends StatefulWidget {
  const DeckPage({super.key});

  @override
  State<DeckPage> createState() => _DeckState();
}

class _DeckState extends State<DeckPage> {
  late DeckService _deckService;

  @override
  initState() {
    super.initState();
    _deckService = DeckService();
  }

  // https://docs.flutter.dev/cookbook/navigation/navigate-with-arguments
  // https://www.woolha.com/tutorials/flutter-using-futurebuilder-widget-examples
  @override
  Widget build(BuildContext context) {
    ValueNotifier<bool> fabExtended = ValueNotifier(false);
    _deckService.initializeChangeNotify();
    return ValueListenableBuilder(
      valueListenable: _deckService.changeNotify,
      builder: (BuildContext context, bool val, Widget? child) {
        return Scaffold(
          appBar: const BasicAppBar(title: 'Decks'),
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
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      FutureBuilder(
                        future: _deckService.getDeckList(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const CircularProgressIndicator(),
                                Visibility(
                                  visible: snapshot.hasData,
                                  child: const Text(
                                    "Warte auf Decks",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 24),
                                  ),
                                )
                              ],
                            );
                          } else if (snapshot.connectionState ==
                              ConnectionState.done) {
                            if (snapshot.hasError) {
                              return Text(snapshot.error.toString());
                            } else if (snapshot.hasData) {
                              return snapshot.data != null &&
                                      snapshot.data!.isNotEmpty
                                  ? Expanded(
                                      child: SingleChildScrollView(
                                        child: Container(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 0, 64),
                                          child: Column(children: [
                                            for (var deck in snapshot.data!)
                                              DeckExpandableLoader(
                                                futureDeckModel: _deckService
                                                    .deckFromNameAndCardIds(
                                                        deck.name,
                                                        deck.cardIds),
                                                onLongPress: () =>
                                                    showDialog<String>(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) =>
                                                          DeleteDeckDialog(
                                                    onDelete: () => setState(
                                                      () {
                                                        _deckService
                                                            .deleteDeckByName(
                                                                deck.name);
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ),
                                          ]),
                                        ),
                                      ),
                                    )
                                  : const Text('Keine Decks gefunden');
                            } else {
                              return const Text('Keine Decks gefunden');
                            }
                          } else {
                            return Text('State: ${snapshot.connectionState}');
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(bottom: 22, left: 22, child: ButtonPlayerCount()),
            ],
          ),
          floatingActionButton: ValueListenableBuilder(
            valueListenable: fabExtended,
            builder: (BuildContext context, bool val, Widget? child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Visibility(
                    maintainSize: true,
                    maintainAnimation: true,
                    maintainState: true,
                    visible: fabExtended.value,
                    child: Transform.scale(
                      scale: 0.8,
                      child: FloatingActionButtonCoin(
                        onPressed: () =>
                            Navigator.pushNamed(context, route.createDeckPage),
                        icon: Icons.shuffle,
                        tooltip: 'Deck mit zufälligen Karten erstellen',
                      ),
                    ),
                  ),
                  Visibility(
                    maintainSize: true,
                    maintainAnimation: true,
                    maintainState: true,
                    visible: fabExtended.value,
                    child: Transform.scale(
                      scale: 0.8,
                      child: FloatingActionButtonCoin(
                        onPressed: () =>
                            Navigator.pushNamed(context, route.createDeckPage),
                        icon: Icons.checklist,
                        tooltip: 'Deck mit ausgewählten Karten erstellen',
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  FloatingActionButtonCoin(
                    onPressed: () => fabExtended.value = !fabExtended.value,
                    icon: Icons.play_arrow,
                    tooltip: 'Neues Deck erstellen',
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
