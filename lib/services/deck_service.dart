import 'dart:collection';
import 'dart:convert';
import 'dart:developer';

import 'package:dominion_comanion/database/card_database.dart';
import 'package:dominion_comanion/database/deck_database.dart';
import 'package:dominion_comanion/database/model/deck/deck_db_model.dart';
import 'package:dominion_comanion/helpers/shuffle.dart';
import 'package:dominion_comanion/model/card/card_model.dart';
import 'package:dominion_comanion/model/card/card_type_infos.dart';
import 'package:dominion_comanion/model/content/content_model.dart';
import 'package:dominion_comanion/model/deck/deck_model.dart';
import 'package:dominion_comanion/model/end/end_model.dart';
import 'package:dominion_comanion/model/hand/hand_model.dart';
import 'package:dominion_comanion/model/hand/hand_type_enum.dart';
import 'package:dominion_comanion/services/card_service.dart';
import 'package:dominion_comanion/services/content_service.dart';
import 'package:dominion_comanion/services/end_service.dart';
import 'package:dominion_comanion/services/hand_service.dart';
import 'package:flutter/foundation.dart';

class DeckService {
  final DeckDatabase _deckDatabase = DeckDatabase();
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
      HandModel handMoneyCards,
      HandModel handOtherCards,
      HandModel handContents,
      EndModel end) {
    return DeckModel(name, cards, additionalCards, content, handMoneyCards,
        handOtherCards, handContents, end);
  }

  Future<DeckModel> deckFromDBModel(DeckDBModel deckDBModel) async {
    var cardIds = deckDBModel.cardIds;
    var activeExpansionIds = getActiveExpansionIdsByCardIds(cardIds);
    var cards = await _cardService.getCardsByCardIds(cardIds);
    var additionalCards = await getAdditionalCardsByCards(cards);
    var allCardIds = [...cards, ...additionalCards].map((e) => e.id).toList();
    var ret = DeckModel(
      deckDBModel.name,
      cards,
      additionalCards,
      await getContentByCardIdsAndActiveExpansionIds(
          cardIds, activeExpansionIds),
      await getHandByCardsAndActiveExpansionIdsAndType(
          cards, activeExpansionIds, HandTypeEnum.moneyCards),
      await getHandByCardsAndActiveExpansionIdsAndType(
          cards, activeExpansionIds, HandTypeEnum.otherCards),
      await getHandByCardsAndActiveExpansionIdsAndType(
          cards, activeExpansionIds, HandTypeEnum.contents),
      await getEndByCardIdsAndActiveExpansionIds(
          allCardIds, activeExpansionIds),
    );
    return ret;
  }

  Future<List<CardModel>> getAdditionalCardsByCards(
      List<CardModel> cards) async {
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
    List<CardModel> whenDeckConsistsOfXCardsOfExpansionCountCards =
        await Future.wait(
            (await _cardService.getWhenDeckConsistsOfXCardsOfExpansionCount())
                .map((card) async => CardModel.fromDBModel(card)));

    for (var whenDeckConsistsOfXCardTypesCard
        in whenDeckConsistsOfXCardTypesCards) {
      var expansionCardCount = 0;
      for (var card in cards) {
        if (whenDeckConsistsOfXCardTypesCard.getExpansionId() ==
            card.getExpansionId()) {
          var conditionTypeLists = whenDeckConsistsOfXCardTypesCard
              .whenDeckConsistsOfXCardTypesOfExpansion!.values.first;
          for (var conditionTypeList in conditionTypeLists) {
            if (listEquals(conditionTypeList, card.cardTypes)) {
              expansionCardCount++;
            }
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
      for (var selectedCard in cards) {
        if (whenDeckConsistsOfXCardsCard.whenDeckConsistsOfXCards!.values.first
            .contains(selectedCard.id)) {
          cardCount++;
        }
      }
      if (cardCount >=
          whenDeckConsistsOfXCardsCard.whenDeckConsistsOfXCards!.keys.first) {
        additionalCards.add(whenDeckConsistsOfXCardsCard);
      }
    }

    var expansionCardCountMap = <String, int>{};
    for (var selectedCard in cards) {
      var expansionId = selectedCard.getExpansionId();
      if (expansionCardCountMap.containsKey(expansionId)) {
        expansionCardCountMap[expansionId] =
            expansionCardCountMap[expansionId]! + 1;
      } else {
        expansionCardCountMap[expansionId] = 1;
      }
    }
    for (var whenDeckConsistsOfXCardsOfExpansionCountCard
        in whenDeckConsistsOfXCardsOfExpansionCountCards) {
      var expansionCardCount = expansionCardCountMap[
          whenDeckConsistsOfXCardsOfExpansionCountCard.getExpansionId()];
      if (expansionCardCount != null &&
          expansionCardCount >=
              whenDeckConsistsOfXCardsOfExpansionCountCard
                  .whenDeckConsistsOfXCardsOfExpansionCount!) {
        additionalCards.add(whenDeckConsistsOfXCardsOfExpansionCountCard);
      }
    }

    var containsPotions = false;

    for (var card in cards) {
      if (!containsPotions && card.cardCost.potion != "") {
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
          await _contentService.getContentByExpansionId(expansionId);
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

  Future<HandModel> getHandByCardsAndActiveExpansionIdsAndType(
      List<CardModel> cards,
      List<String> activeExpansionIds,
      HandTypeEnum type) async {
    List<HandModel> alwaysHand = await Future.wait(
        (await _handService.getAlwaysHandsByType(type))
            .map((end) async => HandModel.fromDBModel(end)));
    HandModel hand = HandModel.empty("new_hand_model");
    if (alwaysHand.isNotEmpty) {
      hand = alwaysHand.first;
      hand.id = "new_hand_model";
    }
    for (var expansionId in activeExpansionIds) {
      var expansionHandDBModel =
          await _handService.getHandsByExpansionIdAndType(expansionId, type);
      for (var handDBModel in expansionHandDBModel) {
        var handModel = HandModel.fromDBModel(handDBModel);
        var addToHand = false;
        if (handModel.whenDeckConsistsOfXCardsOfExpansionCount != null) {
          var count = 0;
          for (var card in cards) {
            if (card.getExpansionId() == handModel.getExpansionId()) {
              count++;
            }
            if (count >= handModel.whenDeckConsistsOfXCardsOfExpansionCount!) {
              addToHand = true;
              break;
            }
          }
        }
        if (handModel.whenDeckConsistsOfXCards != null) {
          for (var entry in handModel.whenDeckConsistsOfXCards!.entries) {
            var count = 0;
            for (var cardId in entry.value) {
              if (cards.where((element) => element.id == cardId).isNotEmpty) {
                count++;
              }
              if (count >= entry.key) {
                addToHand = true;
                break;
              }
            }
          }
        }
        if (addToHand) {
          if (handModel.elementIdCountMap != null) {
            hand.elementIdCountMap = handModel.elementIdCountMap;
          }
          if (handModel.additionalElementIdCountMap != null) {
            hand.additionalElementIdCountMap ??= {};
            hand.additionalElementIdCountMap!
                .addAll(handModel.additionalElementIdCountMap!);
          }
        }
      }
    }
    for (var expansionId in activeExpansionIds) {
      var expansionHandDBModel =
          await _handService.getHandsByExpansionIdAndType(expansionId, type);
      for (var handDBModel in expansionHandDBModel) {
        var handModel = HandModel.fromDBModel(handDBModel);
        if (handModel.elementsReplaceMap != null) {
          Map shuffledElementsReplaceMap =
              Shuffle.shuffleMap(handModel.elementsReplaceMap!);
          shuffledElementsReplaceMap.forEach((key, values) {
            if (cards.map((card) => card.id).contains(key)) {
              for (var value in List<String>.from(values)) {
                if (hand.elementIdCountMap != null &&
                    hand.elementIdCountMap![value] != null &&
                    hand.elementIdCountMap![value]! > 0) {
                  hand.elementIdCountMap![value] =
                      hand.elementIdCountMap![value]! - 1;
                  if (hand.elementIdCountMap![key] != null) {
                    hand.elementIdCountMap![key] =
                        hand.elementIdCountMap![key]! + 1;
                  } else {
                    hand.elementIdCountMap![key] = 1;
                  }
                }
              }
            }
          });
        }
      }
    }
    return hand;
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
