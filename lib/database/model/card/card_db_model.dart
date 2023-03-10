import 'dart:convert';
import 'dart:developer';

import 'package:dominion_comanion/model/card/card_model.dart';
import 'package:dominion_comanion/model/card/card_type_enum.dart';
import 'package:dominion_comanion/model/deck/deck_model.dart';

import 'card_cost_db_model.dart';

class CardDBModel {
  late String id;
  late String name;
  late bool always;
  late Map<int, List<List<CardTypeEnum>>>?
      whenDeckConsistsOfXCardTypesOfExpansion;
  late String setId;
  late String parentId;
  late List<String> relatedCardIds;
  late bool invisible;
  late List<CardTypeEnum> cardTypes;
  late CardCostDBModel cardCost;
  late String text;
  late List<String> count;

  CardDBModel(this.id, this.name, this.always, this.setId, this.parentId,
      this.cardTypes, this.cardCost, this.text, this.count);

  CardDBModel.fromDB(Map<String, dynamic> dbData) {
    id = dbData['id'];
    name = dbData['name'];
    always = dbData['always'] != null ? dbData['always'] > 0 : false;
    whenDeckConsistsOfXCardTypesOfExpansion =
        dbData['whenDeckConsistsOfXCardTypesOfExpansion'] != ''
            ? CardModel.whenDeckConsistsOfXCardTypesOfExpansionFromJSON(
                jsonDecode(dbData['whenDeckConsistsOfXCardTypesOfExpansion']))
            : null;
    setId = dbData['setId'] ?? '';
    parentId = dbData['parentId'] ?? '';
    relatedCardIds = dbData['relatedCardIds'] != null
        ? dbData['relatedCardIds'].toString().split(',')
        : List.empty();
    invisible = dbData['invisible'] != null ? dbData['invisible'] > 0 : false;
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
                ? whenDeckConsistsOfXCardTypesOfExpansionToDB(
                    whenDeckConsistsOfXCardTypesOfExpansion!)
                : '',
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

  String whenDeckConsistsOfXCardTypesOfExpansionToDB(
      Map<int, List<List<CardTypeEnum>>> value) {
    Map<String, List<String>> retMap = {};
    for (var valueKey in value.keys) {
      retMap['"$valueKey"'] = value[valueKey]!
          .map((e) => '"${e.map((e) => e.name).join(", ")}"')
          .toList();
    }
    var ret = retMap.toString();
    ret.replaceAll("=", "-");
    return ret;
  }
}
