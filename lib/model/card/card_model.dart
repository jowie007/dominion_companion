import 'dart:collection';
import 'dart:convert';
import 'dart:developer';

import 'package:dominion_comanion/database/model/card/card_db_model.dart';

import 'card_cost_model.dart';
import 'card_type_enum.dart';

class CardModel {
  late String id;
  late String name;
  late bool always;
  late Map<int, List<List<CardTypeEnum>>>?
      whenDeckConsistsOfXCardTypesOfExpansion;
  late Map<int, List<String>>? whenDeckConsistsOfXCards;
  late bool whenDeckContainsPotions;
  late String setId;
  late String parentId;
  late List<String> relatedCardIds;
  late bool invisible;
  late List<CardTypeEnum> cardTypes;
  late CardCostModel cardCost;
  late String text;
  late List<String> count;
  static final sortTypeOrder = [
    ['aktion-preis', 'aktion-angriff-preis', 'geld-preis'],
    [
      "aktion",
      "aktion-angriff",
      "aktion-reaktion",
      "aktion-punkte",
      "aktion-dauer",
      "aktion-dauer-angriff",
      "aktion-dauer-reaktion",
    ],
    ["punkte"],
    ["geld", "geld-punkte", "geld-dauer"],
    ["fluch"]
  ];

  CardModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    always = json['always'] ?? false;
    whenDeckConsistsOfXCardTypesOfExpansion =
        json['whenDeckConsistsOfXCardTypesOfExpansion'] != null
            ? whenDeckConsistsOfXCardTypesOfExpansionFromJSON(
                json['whenDeckConsistsOfXCardTypesOfExpansion'])
            : null;
    whenDeckConsistsOfXCards = json['whenDeckConsistsOfXCards'] != null
        ? whenDeckConsistsOfXCardsFromJSON(json['whenDeckConsistsOfXCards'])
        : null;
    whenDeckContainsPotions = json['whenDeckContainsPotions'] ?? false;
    setId = json['setId'] ?? '';
    parentId = json['parentId'] ?? '';
    relatedCardIds = json['relatedCardIds'] != null
        ? json['relatedCardIds'].toString().split(',')
        : List.empty();
    invisible = json['invisible'] ?? false;
    cardTypes = cardTypesFromString(json['cardTypes']);
    cardCost = CardCostModel.fromJson(json['cardCost']);
    text = json['text'] ?? '';
    count = json['count'] != null
        ? List<String>.from(json['count'].split(','))
        : List.empty();
  }

  CardModel.fromDBModel(CardDBModel dbModel) {
    id = dbModel.id;
    name = dbModel.name;
    always = dbModel.always;
    whenDeckConsistsOfXCardTypesOfExpansion =
        dbModel.whenDeckConsistsOfXCardTypesOfExpansion;
    whenDeckConsistsOfXCards = dbModel.whenDeckConsistsOfXCards;
    whenDeckContainsPotions = dbModel.whenDeckContainsPotions;
    setId = dbModel.setId;
    parentId = dbModel.parentId;
    relatedCardIds = dbModel.relatedCardIds;
    invisible = dbModel.invisible;
    cardTypes = dbModel.cardTypes;
    cardCost = CardCostModel.fromDBModel(dbModel.cardCost);
    text = dbModel.text;
    count = dbModel.count;
  }

  static String getCardTypesString(List<CardTypeEnum> cardTypes) {
    String fileName = cardTypes
        .map((e) =>
            e.name.substring(0, 1).toUpperCase() +
            e.name.substring(1, e.name.length).toUpperCase())
        .join("-");
    return fileName;
  }

  String getCardExpansion() {
    return id.split('-').first;
  }

  static List<CardTypeEnum> cardTypesFromString(String cardTypes) {
    return List<CardTypeEnum>.from(cardTypes.split(',').map((value) =>
        (CardTypeEnum.values.firstWhere((e) =>
            e.toString() == 'CardTypeEnum.${value.toString().trim()}'))));
  }

  static Map<int, List<List<CardTypeEnum>>>
      whenDeckConsistsOfXCardTypesOfExpansionFromJSON(dynamic json) {
    Map<int, List<List<CardTypeEnum>>> retMap = {};
    var jsonMap = Map<String, List<dynamic>>.from(json);
    for (var stringMapKey in jsonMap.keys) {
      retMap[int.parse(stringMapKey)] = List<String>.from(json[stringMapKey])
          .map((e) => cardTypesFromString(e))
          .toList();
    }
    return retMap;
  }

  static Map<int, List<String>> whenDeckConsistsOfXCardsFromJSON(dynamic json) {
    Map<int, List<String>> retMap = {};
    var jsonMap = Map<String, List<dynamic>>.from(json);
    for (var stringMapKey in jsonMap.keys) {
      retMap[int.parse(stringMapKey)] =
          List<String>.from(json[stringMapKey]).toList();
    }
    return retMap;
  }

  static int sortCardComparison(CardModel card1, CardModel card2) {
    final cardTypes1 =
        CardModel.getCardTypesString(card1.cardTypes).toLowerCase();
    final cardTypes2 =
        CardModel.getCardTypesString(card2.cardTypes).toLowerCase();
    var cardPosition1 = 0;
    var cardPosition2 = 0;
    sortTypeOrder.asMap().forEach((index, value) => {
          if (value.contains(cardTypes1)) {cardPosition1 = index},
          if (value.contains(cardTypes2)) {cardPosition2 = index}
        });
    if (cardPosition1 == cardPosition2) {
      if (card1.cardCost.coin == card2.cardCost.coin) {
        if (card1.cardCost.potion == card2.cardCost.potion) {
          if (card1.cardCost.debt == card2.cardCost.debt) {
            return card1.name.compareTo(card2.name);
          }
          return compareStringNumbers(card1.cardCost.debt, card2.cardCost.debt);
        }
        return compareStringNumbers(
            card1.cardCost.potion, card2.cardCost.potion);
      }
      return compareStringNumbers(card1.cardCost.coin, card2.cardCost.coin);
    }
    return cardPosition1 > cardPosition2 ? 1 : -1;
  }

  static int compareStringNumbers(String stringNumber1, String stringNumber2) {
    if (stringNumber1 == "") {
      stringNumber1 = "0";
    }
    if (stringNumber2 == "") {
      stringNumber2 = "0";
    }
    var number1 = int.parse(stringNumber1.split(RegExp(r'\D')).first);
    var number2 = int.parse(stringNumber2.split(RegExp(r'\D')).first);
    var ret = 0;
    if (number1 < number2) {
      ret = -1;
    } else if (number1 > number2) {
      ret = 1;
    }
    return ret;
  }
}
