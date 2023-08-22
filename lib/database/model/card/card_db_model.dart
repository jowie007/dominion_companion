import 'dart:convert';

import 'package:dominion_companion/helpers/converters.dart';
import 'package:dominion_companion/model/card/card_model.dart';
import 'package:dominion_companion/model/card/card_type_enum.dart';

import 'card_cost_db_model.dart';

class CardDBModel {
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
  late CardCostDBModel cardCost;
  late String text;
  late List<String> count;

  CardDBModel.fromDB(Map<String, dynamic> dbData) {
    id = dbData['id'];
    name = dbData['name'];
    always = dbData['always'] != null ? dbData['always'] > 0 : false;
    whenDeckConsistsOfXCardTypesOfExpansion =
        dbData['whenDeckConsistsOfXCardTypesOfExpansion'] != ''
            ? CardModel.whenDeckConsistsOfXCardTypesOfExpansionFromJSON(
                jsonDecode(dbData['whenDeckConsistsOfXCardTypesOfExpansion']))
            : null;
    whenDeckConsistsOfXCards = dbData['whenDeckConsistsOfXCards'] != ''
        ? CardModel.whenDeckConsistsOfXCardsFromJSON(
            jsonDecode(dbData['whenDeckConsistsOfXCards']))
        : null;
    whenDeckConsistsOfXCardsOfExpansionCount =
        dbData['whenDeckConsistsOfXCardsOfExpansionCount'];
    whenDeckContainsPotions = dbData['whenDeckContainsPotions'] != null
        ? dbData['whenDeckContainsPotions'] > 0
        : false;
    supply = dbData['supply'] != null ? dbData['supply'] > 0 : true;
    setId = dbData['setId'] ?? '';
    parentId = dbData['parentId'] ?? '';
    relatedCardIds = dbData['relatedCardIds'] != null
        ? dbData['relatedCardIds'].toString().split(',')
        : List.empty();
    invisible = dbData['invisible'] != null
        ? dbData['invisible'] > 0 ||
            setId != "" ||
            whenDeckContainsPotions ||
            whenDeckConsistsOfXCardTypesOfExpansion != null ||
            whenDeckConsistsOfXCards != null ||
            whenDeckConsistsOfXCardsOfExpansionCount != null
        : false;
    cardTypes = CardModel.cardTypesFromString(dbData['cardTypes']);
    cardCost = CardCostDBModel(dbData['coin'].toString(),
        dbData['debt'].toString(), dbData['potion'].toString());
    text = dbData['text'] ?? '';
    count = dbData['count'] != null
        ? List<String>.from(dbData['count'].split(','))
        : List.empty();
  }

  CardDBModel.fromModel(CardModel model) {
    id = model.id;
    name = model.name;
    always = model.always;
    whenDeckConsistsOfXCardTypesOfExpansion =
        model.whenDeckConsistsOfXCardTypesOfExpansion;
    whenDeckConsistsOfXCards = model.whenDeckConsistsOfXCards;
    whenDeckConsistsOfXCardsOfExpansionCount =
        model.whenDeckConsistsOfXCardsOfExpansionCount;
    whenDeckContainsPotions = model.whenDeckContainsPotions;
    supply = model.supply;
    setId = model.setId;
    parentId = model.parentId;
    relatedCardIds = model.relatedCardIds;
    invisible = model.invisible;
    cardTypes = model.cardTypes;
    cardCost = CardCostDBModel.fromModel(model.cardCost);
    text = model.text;
    count = model.count;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'always': always ? 1 : 0,
        'whenDeckConsistsOfXCardTypesOfExpansion':
            whenDeckConsistsOfXCardTypesOfExpansion != null
                ? Converters.intCardTypeEnumListListMapToDB(
                    whenDeckConsistsOfXCardTypesOfExpansion!)
                : '',
        'whenDeckConsistsOfXCards': whenDeckConsistsOfXCards != null
            ? Converters.intStringListMapToDB(whenDeckConsistsOfXCards!)
            : '',
        'whenDeckConsistsOfXCardsOfExpansionCount':
            whenDeckConsistsOfXCardsOfExpansionCount,
        'whenDeckContainsPotions': whenDeckContainsPotions ? 1 : 0,
        'supply': supply ? 1 : 0,
        'setId': setId,
        'parentId': parentId,
        'relatedCardIds': relatedCardIds.join(','),
        'invisible': invisible ? 1 : 0,
        'cardTypes': cardTypes
            .map((e) =>
                e.toString().split('.')[e.toString().split('.').length - 1])
            .join(","),
        'coin': cardCost.coin,
        'debt': cardCost.debt,
        'potion': cardCost.potion,
        'text': text,
        'count': count.isNotEmpty ? count.join(',') : null,
      };
}
