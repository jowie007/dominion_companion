import 'dart:developer';

import 'package:dominion_comanion/components/basic_appbar.dart';
import 'package:dominion_comanion/components/button_player_count.dart';
import 'package:dominion_comanion/components/deck_expandable_loader.dart';
import 'package:dominion_comanion/components/name_deck_dialog.dart';
import 'package:dominion_comanion/components/floating_action_button_coin.dart';
import 'package:dominion_comanion/model/deck/deck_model.dart';
import 'package:dominion_comanion/services/deck_service.dart';
import 'package:dominion_comanion/services/temporary_deck_service.dart';
import 'package:flutter/material.dart';

class DeckInfoPage extends StatefulWidget {
  const DeckInfoPage({super.key});

  @override
  State<DeckInfoPage> createState() => _DeckInfoState();
}

class _DeckInfoState extends State<DeckInfoPage> {
  @override
  initState() {
    super.initState();
  }

  final _temporaryDeckService = TemporaryDeckService();
  final _deckService = DeckService();

  // https://www.woolha.com/tutorials/flutter-using-futurebuilder-widget-examples
  @override
  Widget build(BuildContext context) {
    late DeckModel temporaryDeck;
    return Scaffold(
      appBar: const BasicAppBar(title: 'Deck Info'),
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
            padding: const EdgeInsets.all(20),
            child: Container(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 64),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: DeckExpandableLoader(
                  futureDeckModel: _temporaryDeckService.temporaryDeck,
                  onLoaded: (deckModel) => temporaryDeck = deckModel,
                ),
              ),
            ),
          ),
          const Positioned(bottom: 22, left: 22, child: ButtonPlayerCount()),
        ],
      ),
      floatingActionButton: !_temporaryDeckService.saved
          ? FloatingActionButtonCoin(
              icon: Icons.save,
              tooltip: "Deck speichern",
              onPressed: () => showDialog<String>(
                context: context,
                builder: (BuildContext context) => NameDeckDialog(
                  onSaved: (deckName) => setState(
                    () {
                      temporaryDeck.name = deckName;
                      for (var element in temporaryDeck.cards) {
                        log("CARDO " + element.name);
                      }
                      _deckService.saveDeck(temporaryDeck);
                      _temporaryDeckService.saved = true;
                    },
                  ),
                ),
              ),
            )
          : Container(),
    );
  }
}
