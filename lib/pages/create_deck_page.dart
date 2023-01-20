import 'dart:developer';

import 'package:dominion_comanion/components/basic_appbar.dart';
import 'package:dominion_comanion/components/expansion_expandable.dart';
import 'package:dominion_comanion/database/card_database.dart';
import 'package:dominion_comanion/database/expansion_database.dart';
import 'package:dominion_comanion/database/model/card/card_cost_db_model.dart';
import 'package:dominion_comanion/database/model/card/card_db_model.dart';
import 'package:dominion_comanion/database/model/card/card_type_db_model.dart';
import 'package:dominion_comanion/database/model/deck/deck_db_model.dart';
import 'package:dominion_comanion/database/model/expansion/expansion_db_model.dart';
import 'package:dominion_comanion/services/deck_service.dart';
import 'package:dominion_comanion/services/expansion_service.dart';
import 'package:dominion_comanion/services/json_service.dart';
import 'package:flutter/material.dart';

class CreateDeckPage extends StatefulWidget {
  const CreateDeckPage({super.key});

  @override
  State<CreateDeckPage> createState() => _CreateDeckState();
}

class _CreateDeckState extends State<CreateDeckPage> {
  late DeckService _deckService;
  late Future<List<DeckDBModel>> _decks;
  late ExpansionDatabase _expansionDatabase;
  late CardDatabase _cardDatabase;

  @override
  initState() {
    super.initState();
    _deckService = DeckService();
    _decks = _deckService.getDeckList();
    _expansionDatabase = ExpansionDatabase();
    _cardDatabase = CardDatabase();
  }

  // https://www.woolha.com/tutorials/flutter-using-futurebuilder-widget-examples
  @override
  Widget build(BuildContext context) {
    ExpansionService().loadAllExpansions();
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
          Column(
            children: [
              ExpansionExpandable(title: "Seaside", cards: [
                CardDBModel(
                    "1",
                    "Testkarte",
                    CardTypeDBModel(false, false, false, false, true, true),
                    CardCostDBModel(1, 0, 1),
                    "Beschreibung")
              ]),
              ExpansionExpandable(title: "Empires", cards: [
                CardDBModel(
                    "1",
                    "Testkarte",
                    CardTypeDBModel(false, false, false, false, true, true),
                    CardCostDBModel(1, 0, 1),
                    "Beschreibung")
              ]),
              ExpansionExpandable(title: "Nocturne", cards: [
                CardDBModel(
                    "1",
                    "Testkarte",
                    CardTypeDBModel(false, false, false, false, true, true),
                    CardCostDBModel(1, 0, 1),
                    "Beschreibung")
              ])
            ],
          ),
        ],
      ),
    );
  }
}
