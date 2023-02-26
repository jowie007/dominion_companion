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
  late Map<int, List<List<CardTypeEnum>>>? whenDeckConsistsOfXCardTypesOfExpansion;
  late String setId;
  late String parentId;
  late List<String> relatedCardIds;
  late bool invisible;
  late List<CardTypeEnum> cardTypes;
  late CardCostModel cardCost;
  late String text;
  late List<String> count;

  CardModel(this.id, this.name, this.cardTypes, this.cardCost, this.text);

  CardModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    always = json['always'] ?? false;
    whenDeckConsistsOfXCardTypesOfExpansion =
        json['whenDeckConsistsOfXCardTypesOfExpansion'] != null
            ? whenDeckConsistsOfXCardTypesOfExpansionFromJSON(
                json['whenDeckConsistsOfXCardTypesOfExpansion'])
            : null;
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
    // Müsste erledigt sein
    // TODO Type ist bei
    // Holen aus JSON -> _InternalLinkedHashMap<String, dynamic>
    // Holen aus DB -> String
    log(json.runtimeType.toString());
    Map<int, List<List<CardTypeEnum>>> retMap = {};
    var jsonMap = Map<String, List<dynamic>>.from(json);
    for (var stringMapKey in jsonMap.keys) {
      retMap[int.parse(stringMapKey)] = List<String>.from(json[stringMapKey])
          .map((e) => cardTypesFromString(e))
          .toList();
    }
    return retMap;
  }
}
