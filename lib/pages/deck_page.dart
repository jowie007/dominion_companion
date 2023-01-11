import 'package:dominion_comanion/components/basic_appbar.dart';
import 'package:dominion_comanion/components/create_deck_component.dart';
import 'package:dominion_comanion/components/deck_component.dart';
import 'package:dominion_comanion/model/deck/deck_model.dart';
import 'package:dominion_comanion/services/deck_service.dart';
import 'package:flutter/material.dart';

class DeckPage extends StatefulWidget {
  const DeckPage({super.key});

  @override
  State<DeckPage> createState() => _DeckState();
}

class _DeckState extends State<DeckPage> {
  late DeckService _deckService;
  late Future<List<Deck>> _decks;

  @override
  initState() {
    super.initState();
    _deckService = DeckService();
    _decks = _deckService.getDeckList();
  }

  // https://www.woolha.com/tutorials/flutter-using-futurebuilder-widget-examples
  @override
  Widget build(BuildContext context) {
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
                children:  [
                  const CreateDeckButton(),
                  const SizedBox(height: 10),
                  FutureBuilder(
                    future: _decks,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
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
                              ? DeckComponent(deck: snapshot.data![0])
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
        ],
      ),
    );
  }
}
