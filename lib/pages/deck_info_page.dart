import 'package:dominion_companion/components/basic_appbar.dart';
import 'package:dominion_companion/components/button_player_count.dart';
import 'package:dominion_companion/components/deck_expandable_loader.dart';
import 'package:dominion_companion/components/floating_action_button_coin.dart';
import 'package:dominion_companion/components/name_deck_dialog.dart';
import 'package:dominion_companion/model/deck/deck_model.dart';
import 'package:dominion_companion/services/audio_service.dart';
import 'package:dominion_companion/services/deck_service.dart';
import 'package:dominion_companion/services/temporary_deck_service.dart';
import 'package:flutter/material.dart';

class DeckInfoPage extends StatefulWidget {
  const DeckInfoPage({super.key});

  @override
  State<DeckInfoPage> createState() => _DeckInfoState();
}

class _DeckInfoState extends State<DeckInfoPage> {
  Key _deckKey = UniqueKey();

  @override
  initState() {
    super.initState();
  }

  final _temporaryDeckService = TemporaryDeckService();
  final _deckService = DeckService();
  final _audioService = AudioService();

  ScaffoldMessengerState get scaffoldMessenger => ScaffoldMessenger.of(context);

  void onCardReplace(Future<bool> hasChanged) async {
    if (!(await hasChanged)) {
      scaffoldMessenger.showSnackBar(const SnackBar(
          content: Text('Die Karte konnte nicht ersetzt werden.')));
    } else {
      setState(() {
        _deckKey = UniqueKey();
      });
    }
  }

  void onCardAdd(Future<bool> hasChanged) async {
    if (!(await hasChanged)) {
      scaffoldMessenger.showSnackBar(const SnackBar(
          content: Text('Die Karte konnte nicht hinzugefügt werden.')));
    } else {
      setState(() {
        _deckKey = UniqueKey();
      });
    }
  }

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
            child: Container(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 64),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: DeckExpandableLoader(
                    key: _deckKey,
                    futureDeckModel: _temporaryDeckService.temporaryDeck,
                    initiallyExpanded: true,
                    isNewlyCreated: true,
                    onLoaded: (deckModel) => {
                          temporaryDeck = deckModel,
                          _audioService.stopPlaying()
                        },
                    onCardReplace: (hasChanged) => onCardReplace(hasChanged),
                    onCardAdd: (hasChanged) => onCardAdd(hasChanged)),
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
                  onSaved: (deckName, deckDescription) => setState(
                    () {
                      temporaryDeck.name = deckName;
                      temporaryDeck.description = deckDescription;
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
