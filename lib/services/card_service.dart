import 'dart:developer';

import 'package:dominion_comanion/database/card_database.dart';
import 'package:dominion_comanion/database/model/card/card_db_model.dart';
import 'package:dominion_comanion/database/model/expansion/expansion_db_model.dart';
import 'package:dominion_comanion/model/card/card_model.dart';
import 'package:dominion_comanion/model/card/card_type_colors_map.dart';
import 'package:dominion_comanion/model/card/card_type_enum.dart';
import 'package:flutter/material.dart';

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

  Future<List<String>> getCardIdsForPopup(CardModel card) async {
    return !card.id.contains('-set-')
        ? [card.id]
        : await getCardIdsBySetId(card.id);
  }

  Future<List<String>> getCardIdsBySetId(String setId) async {
    return await Future.wait(
        (await getCardsBySetId(setId)).map((card) async => card.id));
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

  String filterCardName(List<CardModel> cards, String cardId) {
    var ret = cards.where((element) => element.id == cardId);
    return ret.isNotEmpty ? ret.first.name : 'Karte nicht gefunden';
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
