import 'dart:developer';

import 'package:dominion_comanion/database/card_database.dart';
import 'package:dominion_comanion/database/deck_database.dart';
import 'package:dominion_comanion/database/model/deck/deck_db_model.dart';
import 'package:dominion_comanion/model/card/card_model.dart';
import 'package:dominion_comanion/model/content/content_model.dart';
import 'package:dominion_comanion/model/deck/deck_model.dart';
import 'package:dominion_comanion/model/end/end_model.dart';
import 'package:dominion_comanion/model/hand/hand_model.dart';
import 'package:dominion_comanion/services/card_service.dart';
import 'package:dominion_comanion/services/content_service.dart';
import 'package:dominion_comanion/services/end_service.dart';
import 'package:dominion_comanion/services/hand_service.dart';
import 'package:flutter/cupertino.dart';

class DeckService {
  final DeckDatabase _deckDatabase = DeckDatabase();
  final CardDatabase _cardDatabase = CardDatabase();
  final CardService _cardService = CardService();
  final ContentService _contentService = ContentService();
  final HandService _handService = HandService();
  final EndService _endService = EndService();
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

  Future<List<DeckModel>> getDeckList() async {
    var deckList = await _deckDatabase.getDeckList();
    return Future.wait(
        deckList.map((deckDBModel) => deckFromDBModel(deckDBModel)));
  }

  Future<int> saveDeck(DeckModel deckModel) {
    changeNotify.value = !changeNotify.value;
    return _deckDatabase.insertDeck(DeckDBModel.fromModel(deckModel));
  }

  Future<int> deleteDeckByName(String name) {
    changeNotify.value = !changeNotify.value;
    return _deckDatabase.deleteDeckByName(name);
  }

  DeckModel deckFromNameAndAdditional(
      String name,
      List<CardModel> cards,
      List<CardModel> additionalCards,
      List<ContentModel> content,
      HandModel hand,
      EndModel end) {
    return DeckModel(name, cards, additionalCards, content, hand, end);
  }

  Future<DeckModel> deckFromDBModel(DeckDBModel deckDBModel) async {
    var cardIds = deckDBModel.cardIds;
    var activeExpansionIds = getActiveExpansionIdsByCardIds(cardIds);
    var cards = await getCardsByCardIds(cardIds);
    var additionalCards = await getAdditionalCardsByCardIds(cardIds);
    var allCardIds = [...cards, ...additionalCards].map((e) => e.id).toList();
    var ret = DeckModel(
      deckDBModel.name,
      cards,
      additionalCards,
      await getContentByCardIdsAndActiveExpansionIds(
          cardIds, activeExpansionIds),
      await getHandByCardIdsAndActiveExpansionIds(cardIds, activeExpansionIds),
      await getEndByCardIdsAndActiveExpansionIds(
          allCardIds, activeExpansionIds),
    );
    return ret;
  }

  Future<List<CardModel>> getCardsByCardIds(List<String> cardIds) {
    return Future.wait(cardIds
        .toList()
        .map((cardId) async =>
            CardModel.fromDBModel(await _cardDatabase.getCardById(cardId)))
        .toList());
  }

  Future<List<CardModel>> getAdditionalCardsByCardIds(
      List<String> cardIds) async {
    var selectedCards = await Future.wait(cardIds
        .toList()
        .map((cardId) async =>
            CardModel.fromDBModel(await _cardDatabase.getCardById(cardId)))
        .toList());
    List<CardModel> additionalCards = [];

    List<CardModel> alwaysCards = await Future.wait(
        (await _cardService.getAlwaysCards())
            .map((card) async => CardModel.fromDBModel(card)));
    List<CardModel> whenDeckConsistsOfXCardTypesCards = await Future.wait(
        (await _cardService.getWhenDeckConsistsOfXCardTypesOfExpansionCards())
            .map((card) async => CardModel.fromDBModel(card)));
    List<CardModel> whenDeckConsistsOfXCardsCards = await Future.wait(
        (await _cardService.getWhenDeckConsistsOfXCards())
            .map((card) async => CardModel.fromDBModel(card)));

    for (var whenDeckConsistsOfXCardTypesCard
        in whenDeckConsistsOfXCardTypesCards) {
      var expansionCardCount = 0;
      for (var selectedCard in selectedCards) {
        if (whenDeckConsistsOfXCardTypesCard.getCardExpansion() ==
            selectedCard.getCardExpansion()) {
          if (whenDeckConsistsOfXCardTypesCard
              .whenDeckConsistsOfXCardTypesOfExpansion!.values.first
              .contains(selectedCard.cardTypes)) {
            expansionCardCount++;
          }
        }
      }
      if (expansionCardCount >=
          whenDeckConsistsOfXCardTypesCard
              .whenDeckConsistsOfXCardTypesOfExpansion!.keys.first) {
        additionalCards.add(whenDeckConsistsOfXCardTypesCard);
      }
    }

    for (var whenDeckConsistsOfXCardsCard in whenDeckConsistsOfXCardsCards) {
      var cardCount = 0;
      for (var selectedCard in selectedCards) {
        whenDeckConsistsOfXCardsCard.whenDeckConsistsOfXCards!.values.first
            .contains(selectedCard.id);
        cardCount++;
      }
      if (cardCount >=
          whenDeckConsistsOfXCardsCard.whenDeckConsistsOfXCards!.keys.first) {
        additionalCards.add(whenDeckConsistsOfXCardsCard);
      }
    }

    var containsPotions = false;

    for (var selectedCard in selectedCards) {
      if (!containsPotions && selectedCard.cardCost.potion != "") {
        containsPotions = true;
      }
    }

    if (containsPotions) {
      additionalCards.addAll(await Future.wait(
          (await _cardService.getWhenDeckContainsPotionsCards())
              .map((card) async => CardModel.fromDBModel(card))));
    }
    additionalCards.addAll(alwaysCards);
    return additionalCards;
  }

  List<String> getActiveExpansionIdsByCardIds(List<String> cardIds) {
    List<String> activeExpansionIds = [];
    for (var cardId in cardIds) {
      var expansion = cardId.split("-")[0];
      if (!activeExpansionIds.contains(expansion)) {
        activeExpansionIds.add(expansion);
      }
    }
    return activeExpansionIds;
  }

  Future<List<ContentModel>> getContentByCardIdsAndActiveExpansionIds(
      List<String> cardIds, List<String> activeExpansionIds) async {
    var alwaysDBContent = await _contentService.getAlwaysContents();
    List<ContentModel> alwaysContent = await Future.wait((alwaysDBContent)
        .map((content) async => ContentModel.fromDBModel(content)));
    var ret = alwaysContent;
    for (var expansionId in activeExpansionIds) {
      var contentModelList =
          await _contentService.getContentByExpansionFromId(expansionId);
      for (var contentModel in contentModelList) {
        if (contentModel.whenDeckConsistsOfXCards != null) {
          for (var entry in contentModel.whenDeckConsistsOfXCards!.entries) {
            var count = 0;
            for (var cardId in entry.value) {
              if (cardIds.contains(cardId)) {
                count++;
              }
              if (count >= entry.key) {
                break;
              }
            }
            if (count >= entry.key) {
              ret.add(ContentModel.fromDBModel(contentModel));
            }
          }
        }
      }
    }
    return ret;
  }

  // TODO Anpassen
  Future<HandModel> getHandByCardIdsAndActiveExpansionIds(
      List<String> cardIds, List<String> activeExpansionIds) async {
    List<HandModel> alwaysHand = await Future.wait(
        (await _handService.getAlwaysHands())
            .map((hand) async => HandModel.fromDBModel(hand)));
    return alwaysHand.first;
  }

  Future<EndModel> getEndByCardIdsAndActiveExpansionIds(
      List<String> cardIds, List<String> activeExpansionIds) async {
    List<EndModel> alwaysEnd = await Future.wait(
        (await _endService.getAlwaysEnds())
            .map((end) async => EndModel.fromDBModel(end)));
    var end = alwaysEnd.first;
    for (var expansionId in activeExpansionIds) {
      var expansionEnd =
          await _endService.getEndByExpansionIdFromDB(expansionId);
      if (expansionEnd != null) {
        if (expansionEnd.emptyCount != null) {
          end.emptyCount = expansionEnd.emptyCount;
        }
        if (expansionEnd.emptyCards.isNotEmpty) {
          end.emptyCards = expansionEnd.emptyCards;
        }
        if (expansionEnd.additionalEmptyCards.isNotEmpty) {
          end.additionalEmptyCards.addAll(expansionEnd.additionalEmptyCards
              .where((cardId) => cardIds.contains(cardId)));
        }
      }
    }
    return end;
  }
}
