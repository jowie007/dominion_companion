import 'dart:developer';

import 'package:dominion_comanion/database/card_database.dart';
import 'package:dominion_comanion/model/card/card_model.dart';
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
  final ContentService _contentService = ContentService();
  final HandService _handService = HandService();
  final EndService _endService = EndService();
  final CardDatabase _cardDatabase = CardDatabase();
  late Future<DeckModel> temporaryDeck;
  bool saved = false;

  static final TemporaryDeckService _temporaryDeckService =
      TemporaryDeckService._internal();

  factory TemporaryDeckService() {
    return _temporaryDeckService;
  }

  TemporaryDeckService._internal();

  Future<void> createTemporaryDeck(String name, List<String> cardIds) async {
    cardIds.shuffle();
    temporaryDeck = createTemporaryDeckAndExtend(name, cardIds);
  }

  Future<DeckModel> createTemporaryDeckAndExtend(
      String name, List<String> cardIds) async {
    log("CREATING");
    var initialCardIds = cardIds.take(DeckService.deckSize).toList();

    var selectedCards = await Future.wait(initialCardIds
        .toList()
        .map((cardId) async =>
            CardModel.fromDBModel(await _cardDatabase.getCardById(cardId)))
        .toList());

    List<String> activeExpansionIds = [];
    for (var cardId in initialCardIds) {
      var expansion = cardId.split("-")[0];
      if (!activeExpansionIds.contains(expansion)) {
        activeExpansionIds.add(expansion);
      }
    }

    List<CardModel> alwaysCards = await Future.wait(
        (await _cardService.getAlwaysCards())
            .map((card) async => CardModel.fromDBModel(card)));
    List<CardModel> whenDeckConsistsOfXCardsCards = await Future.wait(
        (await _cardService.getWhenDeckConsistsOfXCardTypesOfExpansionCards())
            .map((card) async => CardModel.fromDBModel(card)));

    for (var whenDeckConsistsOfXCardsCard in whenDeckConsistsOfXCardsCards) {
      var expansionCardCount = 0;
      for (var selectedCard in selectedCards) {
        if (whenDeckConsistsOfXCardsCard.getCardExpansion() ==
            selectedCard.getCardExpansion()) {
          whenDeckConsistsOfXCardsCard
              .whenDeckConsistsOfXCardTypesOfExpansion!.values.first
              .contains(selectedCard.cardTypes);
          expansionCardCount++;
        }
      }
      if (expansionCardCount >=
          whenDeckConsistsOfXCardsCard
              .whenDeckConsistsOfXCardTypesOfExpansion!.keys.first) {
        selectedCards.add(whenDeckConsistsOfXCardsCard);
      }
    }
    selectedCards.addAll(alwaysCards);

    List<ContentModel> alwaysContent = await Future.wait(
        (await _contentService.getAlwaysContents())
            .map((content) async => ContentModel.fromDBModel(content)));

    List<HandModel> alwaysHand = await Future.wait(
        (await _handService.getAlwaysHands())
            .map((hand) async => HandModel.fromDBModel(hand)));

    List<EndModel> alwaysEnd = await Future.wait(
        (await _endService.getAlwaysEnds())
            .map((end) async => EndModel.fromDBModel(end)));

    log(_deckService
        .deckFromNameAndAdditional(
            name,
            selectedCards,
            alwaysContent.isNotEmpty ? alwaysContent.first : null,
            alwaysHand.first,
            alwaysEnd.first)
        .toString());
    return _deckService.deckFromNameAndAdditional(
        name,
        selectedCards,
        alwaysContent.isNotEmpty ? alwaysContent.first : null,
        alwaysHand.first,
        alwaysEnd.first);
  }
}
