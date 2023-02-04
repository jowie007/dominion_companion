import 'package:dominion_comanion/components/basic_appbar.dart';
import 'package:dominion_comanion/components/deck_expandable.dart';
import 'package:dominion_comanion/components/floating_action_button_coin.dart';
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

  final _selectedCardService = SelectedCardService();

  // https://www.woolha.com/tutorials/flutter-using-futurebuilder-widget-examples
  @override
  Widget build(BuildContext context) {
    _selectedCardService.initializeSelectedCardIds();
    ValueNotifier<bool> notifier = ValueNotifier(false);
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
                      future: _selectedCardService.temporaryDeck,
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
                            return snapshot.data != null
                                ? DeckExpandable(
                                    deckModel: snapshot.data!,
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
      floatingActionButton: FloatingActionButtonCoin(
        icon: Icons.save,
        tooltip: "Deck speichern",
        onPressed: () => (""),
      ),
    );
  }
}
