import 'dart:developer';

import 'package:dominion_comanion/database/card_database.dart';
import 'package:dominion_comanion/database/model/deck/deck_db_model.dart';
import 'package:dominion_comanion/model/card/card_model.dart';
import 'package:dominion_comanion/model/card/card_type_infos.dart';
import 'package:dominion_comanion/model/content/content_model.dart';
import 'package:dominion_comanion/model/deck/deck_model.dart';
import 'package:dominion_comanion/model/end/end_model.dart';
import 'package:dominion_comanion/model/hand/hand_model.dart';
import 'package:dominion_comanion/services/card_service.dart';
import 'package:dominion_comanion/services/content_service.dart';
import 'package:dominion_comanion/services/deck_service.dart';
import 'package:dominion_comanion/services/end_service.dart';
import 'package:dominion_comanion/services/hand_service.dart';

class TemporaryDeckService {
  final DeckService _deckService = DeckService();
  final CardService _cardService = CardService();
  late Future<DeckModel> temporaryDeck;
  bool saved = false;

  static final TemporaryDeckService _temporaryDeckService =
      TemporaryDeckService._internal();

  factory TemporaryDeckService() {
    return _temporaryDeckService;
  }

  TemporaryDeckService._internal();

  Future<void> createTemporaryDBDeck(
      String name, List<String> cardIds, bool cardLimit) async {
    temporaryDeck = createTemporaryDeck(name, cardIds, cardLimit);
  }

  Future<DeckModel> createTemporaryDeck(
      String name, List<String> cardIds, bool cardLimit) async {
    return _deckService.deckFromDBModel(DeckDBModel(null, name, null,
        await filterCards(cardIds, cardLimit), DateTime.now(), null, null));
  }

  Future<List<String>> filterCards(List<String> cardIds, bool cardLimit) async {
    if (!cardLimit) {
      return cardIds;
    }
    const max = 2;
    cardIds.shuffle();
    List<CardModel> cards = await _cardService.getCardsByCardIds(cardIds);
    List<CardModel> vCards = [...cards];
    List<CardModel> hCards = [];
    for (var element in horizontalCards) {
      var count = 0;
      for (var card in cards) {
        if (card.cardTypes.contains(element)) {
          vCards.remove(card);
          if (count < max) {
            hCards.add(card);
            count++;
          }
        }
      }
    }
    return [...hCards, ...vCards.take(DeckService.deckSize).toList()]
        .map((card) => card.id)
        .toList();
  }
}
