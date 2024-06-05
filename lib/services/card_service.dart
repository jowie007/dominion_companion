import 'dart:developer';
import 'dart:math' as math;

import 'package:dominion_companion/database/card_database.dart';
import 'package:dominion_companion/database/model/card/card_db_model.dart';
import 'package:dominion_companion/database/model/expansion/expansion_db_model.dart';
import 'package:dominion_companion/model/card/card_model.dart';
import 'package:dominion_companion/model/card/card_type_colors_map.dart';
import 'package:dominion_companion/model/card/card_type_enum.dart';
import 'package:dominion_companion/services/expansion_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CardService {
  late CardDatabase _cardDatabase;

  CardService() {
    _cardDatabase = CardDatabase();
  }

  Future<int> deleteCardTable() {
    return _cardDatabase.deleteCardTable();
  }

  void insertCardIntoDB(CardDBModel cardDBModel) {
    _cardDatabase.insertCard(cardDBModel);
  }

  Future<void> insertCardModelsIntoDB(List<CardModel> cardModels) {
    return _cardDatabase.insertCards(cardModels
        .map((cardModel) => CardDBModel.fromModel(cardModel))
        .toList());
  }

  Future<List<CardModel>> getCardsByCardIds(List<String> cardIds) {
    return cardIds.isNotEmpty
        ? Future.wait(cardIds
            .toList()
            .map((cardId) async =>
                CardModel.fromDBModel(await _cardDatabase.getCardById(cardId)))
            .toList())
        : Future.wait([]);
  }

  Future<Map<CardModel, List<String>>?> getCardOfTheDay() async {
    int? cardDBSize = await _cardDatabase.getCardsLength();
    if (cardDBSize == null) {
      return null;
    }
    DateTime now = DateTime.now();
    String dateString =
        now.year.toString() + now.month.toString() + now.day.toString();
    int? dateInt = int.tryParse(dateString);
    if (dateInt == null) {
      return null;
    }
    math.Random random = math.Random(dateInt);
    int position = random.nextInt(cardDBSize - 1);
    CardDBModel cardDBModel = await _cardDatabase.getCardAtPosition(position);
    CardModel card = CardModel.fromDBModel(cardDBModel);
    List<String> cardIds = !card.id.contains('-set-')
        ? [card.id]
        : await getCardIdsBySetId(card.id);
    return {card: cardIds};
  }

  Future<List<String>> getCardIdsForPopup(CardModel card) async {
    return !card.id.contains('-set-')
        ? [await getCardImageId(card.id) ?? '']
        : await getCardIdsBySetId(card.id);
  }

  Future<String?> getCardImageId(String cardId) async {
    List<String> expansionIds = await ExpansionService()
        .getAllExpansionIdsStartingWithId(cardId.split("_")[0]);
    if (await testCardImage(cardId)) {
      return cardId;
    } else {
      for (var expansionId in expansionIds) {
        String cardIdRaw = cardId.split("-").sublist(1).join("-");
        String otherId = "$expansionId-$cardIdRaw";
        if (await testCardImage(otherId)) {
          return "$expansionId-$cardIdRaw";
        }
      }
    }
    return null;
  }

  Future<List<String>> getCardIdsBySetId(String setId) async {
    return await Future.wait(
        (await getCardsBySetId(setId)).map((card) async => card.id));
  }

  Future<bool> testCardImage(String cardId) async {
    var split = cardId.split("-");
    if (split[1] != "set") {
      try {
        await rootBundle.load('assets/cards/full/${split[0]}/${split[2]}.png');
        return true;
      } catch (_) {}
    }
    return false;
  }

  void testCardNamesAndImages() async {
    getAllCards().then(
      (cards) async {
        for (var card in cards) {
          var split = card.id.split("-");
          if (split[1] != "set") {
            if (await getCardImageId(card.id) == null) {
              log("${card.id} not found");
            }
          }
        }
      },
    );
  }

  Future<List<CardDBModel>> getAllCards() async {
    return await _cardDatabase.getCardList();
  }

  Future<List<CardDBModel>> getCardsBySetId(String setId) async {
    return await _cardDatabase.getCardsBySetId(setId);
  }

  Future<List<CardDBModel>> getAlwaysCards() async {
    return await _cardDatabase.getAlwaysCardList();
  }

  Future<List<CardDBModel>> getWhenDeckContainsPotionsCards() async {
    return await _cardDatabase.getWhenDeckContainsPotionsCardList();
  }

  Future<List<CardDBModel>>
      getWhenDeckConsistsOfXCardTypesOfExpansionCards() async {
    return await _cardDatabase
        .getWhenDeckConsistsOfXCardTypesOfExpansionCards();
  }

  Future<List<CardDBModel>> getWhenDeckConsistsOfXCards() async {
    return await _cardDatabase.getWhenDeckConsistsOfXCards();
  }

  Future<List<CardDBModel>>
      getWhenDeckConsistsOfXCardsOfExpansionCount() async {
    return await _cardDatabase.getWhenDeckConsistsOfXCardsOfExpansionCount();
  }

  Future<List<CardDBModel>> getCardsByExpansionFromDB(
      ExpansionDBModel expansion) async {
    final cards = expansion.cardIds
        .map((cardId) async => await _cardDatabase.getCardById(cardId))
        .toList();
    return await Future.wait(cards);
  }

  String getFilenameByCardTypes(List<CardTypeEnum> cardTypes) {
    String fileName = cardTypes.map((e) => e.name).join("-");
    return fileName;
  }

  Future<String> filterCardName(List<CardModel> cards, String cardId) async {
    var card = await _cardDatabase.getCardById(cardId);
    return card.name;
  }

  List<Color>? getColorsByCardTypeString(String cardTypeString) {
    final colors = <Color>[];
    final cardColors = cardTypeColorsMap[cardTypeString.toLowerCase()];
    if (cardColors != null) {
      for (var color in cardColors) {
        colors.add(color.withOpacity(0.8));
        colors.add(color.withOpacity(0.8));
      }
    }
    return colors;
  }

  List<double> getStopsByColors(List<Color> colors, double scale) {
    final stops = <double>[];
    final step = colors.length > 2 ? scale / (colors.length / 2) : scale;
    stops.add(0);
    if (step < scale) {
      for (var i = 1; i < colors.length / 2; i++) {
        stops.add((step * i).toDouble());
        stops.add((step * i).toDouble());
      }
    }
    stops.add(scale);
    return stops;
  }
}
