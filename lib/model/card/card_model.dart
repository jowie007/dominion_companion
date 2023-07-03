import 'dart:developer';

import 'package:dominion_companion/database/model/card/card_db_model.dart';

import 'card_cost_model.dart';
import 'card_type_enum.dart';

class CardModel {
  late String id;
  late String name;
  late bool always;
  late Map<int, List<List<CardTypeEnum>>>?
      whenDeckConsistsOfXCardTypesOfExpansion;
  late Map<int, List<String>>? whenDeckConsistsOfXCards;
  late int? whenDeckConsistsOfXCardsOfExpansionCount;
  late bool whenDeckContainsPotions;
  late bool supply;
  late String setId;
  late String parentId;
  late List<String> relatedCardIds;
  late bool invisible;
  late List<CardTypeEnum> cardTypes;
  late CardCostModel cardCost;
  late String text;
  late List<String> count;

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
    whenDeckConsistsOfXCardsOfExpansionCount =
        json['whenDeckConsistsOfXCardsOfExpansionCount'];
    whenDeckContainsPotions = json['whenDeckContainsPotions'] ?? false;
    supply = json['supply'] ?? true;
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
    whenDeckConsistsOfXCardsOfExpansionCount =
        dbModel.whenDeckConsistsOfXCardsOfExpansionCount;
    whenDeckContainsPotions = dbModel.whenDeckContainsPotions;
    supply = dbModel.supply;
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

  String getExpansionId() {
    return id.split('-').first;
  }

  static CardTypeEnum findCardTypeEnumByString(String value) {
    var ret = CardTypeEnum.aktion;
    try {
      ret = CardTypeEnum.values.firstWhere(
          (e) => e.toString() == 'CardTypeEnum.${value.toString().trim()}');
    } catch (e) {
      log("No enum found for $value");
    }
    return ret;
  }

  static List<CardTypeEnum> cardTypesFromString(String cardTypes) {
    return List<CardTypeEnum>.from(
        cardTypes.split(',').map((value) => findCardTypeEnumByString(value)));
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

  static List<List<String>> sortTypeOrder = [
    ["aktion"],
    ["punkte"],
    ["fluch"],
    ["ereignis"],
    ["projekt"],
    ["merkmal"],
    ["landmarke"],
    ["weg"],
    ["geld"],
  ];

  static int sortCardComparisonDeck(CardModel card1, CardModel card2) {
    return sortCardComparison(card1, card2, sortTypeOrder);
  }

  static int sortCardComparisonExpansion(CardModel card1, CardModel card2) {
    return sortCardComparison(card1, card2, []);
  }

  static int sortCardComparison(
      CardModel card1, CardModel card2, List<List<String>> sortTypeOrder) {
    final cardTypes1 =
        CardModel.getCardTypesString(card1.cardTypes).toLowerCase();
    final cardTypes2 =
        CardModel.getCardTypesString(card2.cardTypes).toLowerCase();
    var cardPosition1 = 0;
    var cardPosition2 = 0;
    var index = 1;
    for (var sortTypes in sortTypeOrder) {
      for (var sortType in sortTypes) {
        if (cardTypes1.contains(sortType) && cardPosition1 == 0) {
          cardPosition1 = index;
        }
        if (cardTypes2.contains(sortType) && cardPosition2 == 0) {
          cardPosition2 = index;
        }
      }
      index = index + 1;
    }
    if (!card1.supply) {
      cardPosition1 = cardPosition1 + 1000;
    }
    if (!card2.supply) {
      cardPosition2 = cardPosition2 + 1000;
    }
    if (card1.always) {
      cardPosition1 = cardPosition1 + 1000;
    }
    if (card2.always) {
      cardPosition2 = cardPosition2 + 1000;
    }
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
    var numbers1 = stringNumber1.split(RegExp(r'\D'));
    var numbers2 = stringNumber2.split(RegExp(r'\D'));
    var number1 = -1;
    var number2 = -1;
    if (numbers1.isNotEmpty) {
      number1 = int.tryParse(numbers1.first) ?? 1000;
    }
    if (numbers2.isNotEmpty) {
      number2 = int.tryParse(numbers2.first) ?? 1000;
    }
    var ret = 0;
    if (number1 < number2) {
      ret = -1;
    } else if (number1 > number2) {
      ret = 1;
    }
    return ret;
  }
}
