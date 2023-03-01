import 'dart:developer';

import 'package:dominion_comanion/database/card_database.dart';
import 'package:dominion_comanion/database/deck_database.dart';
import 'package:dominion_comanion/database/model/content/content_db_model.dart';
import 'package:dominion_comanion/database/model/deck/deck_db_model.dart';
import 'package:dominion_comanion/model/card/card_model.dart';
import 'package:dominion_comanion/model/content/content_model.dart';
import 'package:dominion_comanion/model/deck/deck_model.dart';
import 'package:dominion_comanion/model/end/end_model.dart';
import 'package:dominion_comanion/model/hand/hand_model.dart';
import 'package:flutter/cupertino.dart';

class DeckService {
  final DeckDatabase _deckDatabase = DeckDatabase();
  final CardDatabase _cardDatabase = CardDatabase();
  late ValueNotifier<bool> changeNotify;

  static final DeckService _deckService = DeckService._internal();

  static int deckSize = 10;

  factory DeckService() {
    return _deckService;
  }

  DeckService._internal();

  void initializeChangeNotify() {
    changeNotify = ValueNotifier(false);
  }

  Future<List<DeckDBModel>> getDeckList() {
    return _deckDatabase.getDeckList();
  }

  Future<int> saveDeck(DeckModel deckModel) {
    changeNotify.value = !changeNotify.value;
    return _deckDatabase.insertDeck(DeckDBModel.fromModel(deckModel));
  }

  Future<int> deleteDeckByName(String name) {
    changeNotify.value = !changeNotify.value;
    return _deckDatabase.deleteDeckByName(name);
  }

  DeckModel deckFromNameAndAdditional(String name, List<CardModel> cards,
      ContentModel? content, HandModel hand, EndModel end) {
    return DeckModel(name, cards, content, hand, end);
  }

  Future<DeckModel> deckFromDBModel(DeckDBModel deckDBModel) async {
    return DeckModel(
        deckDBModel.name,
        await Future.wait(deckDBModel.cardIds
            .toList()
            .map((cardId) async =>
                CardModel.fromDBModel(await _cardDatabase.getCardById(cardId)))
            .toList()),
        deckDBModel.content != null
            ? ContentModel.fromDBModel(deckDBModel.content!)
            : null,
        HandModel.fromDBModel(deckDBModel.hand),
        EndModel.fromDBModel(deckDBModel.end));
  }
}
