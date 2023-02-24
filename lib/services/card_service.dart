import 'dart:developer';

import 'package:dominion_comanion/database/card_database.dart';
import 'package:dominion_comanion/database/model/card/card_db_model.dart';
import 'package:dominion_comanion/database/model/expansion/expansion_db_model.dart';
import 'package:dominion_comanion/model/card/card_type_colors_map.dart';
import 'package:dominion_comanion/model/card/card_type_enum.dart';
import 'package:flutter/material.dart';

class CardService {
  late CardDatabase _cardDatabase;

  CardService() {
    _cardDatabase = CardDatabase();
  }

  void insertCardIntoDB(CardDBModel cardDBModel) {
    _cardDatabase.insertCard(cardDBModel);
  }

  Future<List<CardDBModel>> getAlwaysCards() async {
    return await _cardDatabase.getAlwaysCardList();
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

  String getCardTypesString(List<CardTypeEnum> cardTypes) {
    String fileName = cardTypes
        .map((e) =>
            e.name.substring(0, 1).toUpperCase() +
            e.name.substring(1, e.name.length).toUpperCase())
        .join("-");
    return fileName;
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
