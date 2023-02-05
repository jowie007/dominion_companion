import 'package:dominion_comanion/components/basic_appbar.dart';
import 'package:dominion_comanion/components/name_deck_dialog.dart';
import 'package:dominion_comanion/components/deck_expandable.dart';
import 'package:dominion_comanion/components/floating_action_button_coin.dart';
import 'package:dominion_comanion/model/deck/deck_model.dart';
import 'package:dominion_comanion/services/deck_service.dart';
import 'package:dominion_comanion/services/temporary_deck_service.dart';
import 'package:flutter/material.dart';

import '../services/selected_card_service.dart';

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
          Stack(
            alignment: Alignment.center,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 64),
                    child: FutureBuilder(
                      future: _temporaryDeckService.temporaryDeck,
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
                                  "Warte auf Erweiterungen",
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
                            if (snapshot.data != null) {
                              temporaryDeck = snapshot.data!;
                            }
                            return snapshot.data != null
                                ? DeckExpandable(
                                    deckModel: temporaryDeck,
                                  )
                                : const Text('Keine Erweiterungen gefunden');
                          } else {
                            return const Text('Keine Erweiterungen gefunden');
                          }
                        } else {
                          return Text('State: ${snapshot.connectionState}');
                        }
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
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
                      _deckService.addDeck(temporaryDeck);
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
