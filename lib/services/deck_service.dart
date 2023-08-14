import 'dart:convert';
import 'dart:io';

import 'package:dominion_companion/database/deck_database.dart';
import 'package:dominion_companion/database/model/deck/deck_db_model.dart';
import 'package:dominion_companion/helpers/shuffle.dart';
import 'package:dominion_companion/model/card/card_model.dart';
import 'package:dominion_companion/model/card/card_type_enum.dart';
import 'package:dominion_companion/model/content/content_model.dart';
import 'package:dominion_companion/model/deck/deck_model.dart';
import 'package:dominion_companion/model/end/end_model.dart';
import 'package:dominion_companion/model/hand/hand_model.dart';
import 'package:dominion_companion/model/hand/hand_type_enum.dart';
import 'package:dominion_companion/services/card_service.dart';
import 'package:dominion_companion/services/content_service.dart';
import 'package:dominion_companion/services/end_service.dart';
import 'package:dominion_companion/services/file_service.dart';
import 'package:dominion_companion/services/hand_service.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class DeckService {
  final DeckDatabase _deckDatabase = DeckDatabase();
  final CardService _cardService = CardService();
  final ContentService _contentService = ContentService();
  final HandService _handService = HandService();
  final EndService _endService = EndService();
  final FileService _fileService = FileService();

  Directory? appDocumentsDir;

  ValueNotifier<bool> notifier = ValueNotifier(false);

  static final DeckService _deckService = DeckService._internal();

  static int deckSize = 10;

  factory DeckService() {
    return _deckService;
  }

  DeckService._internal();

  Future<List<String>?> getCardIdsByDeckId(int id) async {
    final deck = await _deckDatabase.getDeckById(id);
    return deck?.cardIds;
  }

  Future<List<DeckDBModel>?> pickDeckJSONFile() async {
    final file = await _fileService.pickFile();
    if (file == null) {
      return null;
    }
    List<DeckDBModel>? dbDecks;
    dbDecks = await getDBDecksFromJson(await file.readAsString());
    return dbDecks;
  }

  Future<List<DeckDBModel>?> getDBDecksFromJson(String jsonString) async {
    List<DeckDBModel> dbDecks;
    try {
      List<dynamic> decks = jsonDecode(jsonString);
      dbDecks = decks.map((deck) => DeckDBModel.fromDB(deck)).toList();
    } catch (_) {
      return null;
    }
    return dbDecks;
  }

  Future<List<DeckDBModel>> getDBDeckList(
      {bool sortAsc = true, String sortKey = "creationDate"}) async {
    return await _deckDatabase.getDeckList(sortAsc, sortKey);
  }

  Future<List<DeckDBModel>> getDBDeckListWithImages(
      {bool sortAsc = true, String sortKey = "creationDate"}) async {
    var dbDeckList = await _deckDatabase.getDeckList(sortAsc, sortKey);
    for (var dbDeck in dbDeckList) {
      var image = dbDeck.id != null ? await getCachedImage(dbDeck.id!) : null;
      if (image != null && await image.exists()) {
        List<int> bytes = await image.readAsBytes();
        dbDeck.image = base64Encode(bytes);
      }
    }
    return dbDeckList;
  }

  Future<List<DeckModel>> getDeckList(
      {bool sortAsc = true, String sortKey = "creationDate"}) async {
    var deckList = await getDBDeckList(sortKey: sortKey, sortAsc: sortAsc);
    return Future.wait(
        deckList.map((deckDBModel) => deckFromDBModel(deckDBModel)));
  }

  Future<DeckModel?> getDeckByPosition(int position,
      {bool sortAsc = true, String sortKey = "creationDate"}) async {
    DeckDBModel? deckDBModel =
        await _deckDatabase.getDeckByPosition(position, sortAsc, sortKey);
    return deckDBModel != null ? deckFromDBModel(deckDBModel) : null;
  }

  Future<List<String>> getAllDeckNames() async {
    return await _deckDatabase.getAllDeckNames();
  }

  Future<void> updateCardIds(int deckId, List<String> cardIds) {
    notifier.value = !notifier.value;
    return _deckDatabase.updateCardIds(deckId, cardIds);
  }

  Future<int> importDeck(DeckDBModel deckDBModel, {int? deleteId}) async {
    if (deleteId != null && await _deckDatabase.getDeckById(deleteId) != null) {
      _deckDatabase.deleteDeckById(deleteId);
    }
    if (await _deckDatabase.getDeckByName(deckDBModel.name) != null) {
      _deckDatabase.deleteDeckByName(deckDBModel.name);
    }
    deckDBModel.id = null;
    notifier.value = !notifier.value;
    return _deckDatabase.insertDeck(deckDBModel);
  }

  Future<int> updateDeck(DeckModel deckModel) {
    notifier.value = !notifier.value;
    return _deckDatabase.updateDeck(DeckDBModel.fromModel(deckModel));
  }

  Future<int> saveDeck(DeckModel deckModel) {
    notifier.value = !notifier.value;
    return _deckDatabase.insertDeck(DeckDBModel.fromModel(deckModel));
  }

  Future<int> renameDeck(int id, String newName) {
    notifier.value = !notifier.value;
    return _deckDatabase.renameDeck(id, newName);
  }

  Future<int> deleteDeckByName(String name) {
    notifier.value = !notifier.value;
    return _deckDatabase.deleteDeckByName(name);
  }

  Future<int> deleteDeckById(int? id) {
    notifier.value = !notifier.value;
    return _deckDatabase.deleteDeckById(id);
  }

  Future<void> setCachedImage(int deckId, String? base64String) async {
    appDocumentsDir ??= await getApplicationDocumentsDirectory();
    final path = '${appDocumentsDir!.path}/decks/images/$deckId.jpg';
    await removeCachedImage(deckId);
    if (base64String != null) {
      try {
        if (!(await File(path).exists())) {
          final file = await File(path).create(recursive: true);
          file.writeAsBytesSync(base64Decode(base64String));
        }
      } catch (_) {}
    }
  }

  Future<File?> getCachedImage(int deckId) async {
    appDocumentsDir ??= await getApplicationDocumentsDirectory();
    final path = '${appDocumentsDir!.path}/decks/images/$deckId.jpg';
    try {
      if (await File(path).exists()) {
        return File(path);
      } else {
        return null;
      }
    } catch (_) {
      return null;
    }
  }

  Future<void> removeCachedImage(int deckId) async {
    appDocumentsDir ??= await getApplicationDocumentsDirectory();
    final path = '${appDocumentsDir!.path}/decks/images/$deckId.jpg';
    try {
      if (await File(path).exists()) {
        File(path).delete();
      }
    } catch (_) {}
  }

  Future<DeckModel> deckFromDBModel(DeckDBModel deckDBModel) async {
    var cardIds = deckDBModel.cardIds;
    var activeExpansionIds = getActiveExpansionIdsByCardIds(cardIds);
    var cards = await _cardService.getCardsByCardIds(cardIds);
    var additionalCards = await getAdditionalCardsByCards(cards);
    var allCardIds = [...cards, ...additionalCards].map((e) => e.id).toList();
    var ret = DeckModel(
      deckDBModel.id,
      deckDBModel.name,
      deckDBModel.id != null ? await getCachedImage(deckDBModel.id!) : null,
      deckDBModel.creationDate,
      deckDBModel.editDate,
      deckDBModel.rating,
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
      var neededCount = whenDeckConsistsOfXCardTypesCard
          .whenDeckConsistsOfXCardTypesOfExpansion!.keys.first;
      var expansionCardCount = 0;
      for (var card in cards) {
        if (whenDeckConsistsOfXCardTypesCard.getExpansionId() ==
            card.getExpansionId()) {
          var conditionTypeLists = whenDeckConsistsOfXCardTypesCard
              .whenDeckConsistsOfXCardTypesOfExpansion!.values.first;
          for (var conditionTypeList in conditionTypeLists) {
            if (listEquals(conditionTypeList, card.cardTypes)) {
              expansionCardCount++;
              if (expansionCardCount >= neededCount) {
                break;
              }
            }
          }
        }
        if (expansionCardCount >= neededCount) {
          additionalCards.add(whenDeckConsistsOfXCardTypesCard);
          break;
        }
      }
    }

    for (var whenDeckConsistsOfXCardsCard in whenDeckConsistsOfXCardsCards) {
      var cardCount = 0;
      var neededCount =
          whenDeckConsistsOfXCardsCard.whenDeckConsistsOfXCards!.keys.first;
      for (var selectedCard in cards) {
        if (whenDeckConsistsOfXCardsCard.whenDeckConsistsOfXCards!.values.first
            .contains(selectedCard.id)) {
          cardCount++;
          if (cardCount >= neededCount) {
            additionalCards.add(whenDeckConsistsOfXCardsCard);
            break;
          }
        }
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

    additionalCards.shuffle();
    CardModel? verbuendeteCard;
    for (var card in additionalCards) {
      if (card.cardTypes.contains(CardTypeEnum.verbuendete)) {
        verbuendeteCard = card;
        break;
      }
    }
    additionalCards = additionalCards
        .where((card) => !card.cardTypes.contains(CardTypeEnum.verbuendete))
        .toList();
    var ret = additionalCards;
    if (verbuendeteCard != null) {
      ret.add(verbuendeteCard);
    }

    return ret;
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
              break;
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
    // var cardIds = cards.map((card) => card.id);
    for (var expansionId in activeExpansionIds) {
      var expansionHandDBModel =
          await _handService.getHandsByExpansionIdAndType(expansionId, type);
      for (var handDBModel in expansionHandDBModel) {
        var handModel = HandModel.fromDBModel(handDBModel);
        if (handModel.elementsReplaceMap != null) {
          Map shuffledElementsReplaceMap =
              Shuffle.shuffleMap(handModel.elementsReplaceMap!);
          shuffledElementsReplaceMap.forEach((key, values) {
            // if (cardIds.contains(key)) {
            for (var value in List<String>.from(values)) {
              if (hand.elementIdCountMap != null &&
                  hand.elementIdCountMap![value] != null) {
                if (hand.elementIdCountMap![value]! > 1) {
                  hand.elementIdCountMap![value] =
                      hand.elementIdCountMap![value]! - 1;
                } else {
                  hand.elementIdCountMap!.remove(value);
                }
                if (hand.elementIdCountMap![key] != null) {
                  hand.elementIdCountMap![key] =
                      hand.elementIdCountMap![key]! + 1;
                } else {
                  hand.elementIdCountMap![key] = 1;
                }
              }
              // }
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
