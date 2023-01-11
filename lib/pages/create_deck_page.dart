import 'package:dominion_comanion/components/basic_appbar.dart';
import 'package:dominion_comanion/components/create_deck_component.dart';
import 'package:dominion_comanion/components/deck_component.dart';
import 'package:dominion_comanion/components/expansion_expandable.dart';
import 'package:dominion_comanion/model/deck/deck_model.dart';
import 'package:dominion_comanion/services/deck_service.dart';
import 'package:flutter/material.dart';

class CreateDeckPage extends StatefulWidget {
  const CreateDeckPage({super.key});

  @override
  State<CreateDeckPage> createState() => _CreateDeckState();
}

class _CreateDeckState extends State<CreateDeckPage> {
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
      appBar: const BasicAppBar(title: 'Deck erstellen'),
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
          const ExpansionExpandable()
        ],
      ),
    );
  }
}
