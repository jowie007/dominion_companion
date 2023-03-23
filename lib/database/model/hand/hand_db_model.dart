import 'dart:convert';

import 'package:dominion_comanion/model/hand/hand_model.dart';

class HandDBModel {
  late String id;
  late bool always;
  late Map<String, int>? elementIdCountMap;
  late Map<String, int>? additionalElementIdCountMap;
  late Map<int, List<String>>? whenDeckConsistsOfXCards;
  late int? whenDeckConsistsOfXCardsOfExpansionCount;

  HandDBModel.fromDB(Map<String, dynamic> dbData) {
    id = dbData['id'];
    always = dbData['always'] != null ? dbData['always'] > 0 : false;
    elementIdCountMap = dbData['elements'] != null
        ? mapFromDBData(jsonDecode(dbData['elements']))
        : null;
    additionalElementIdCountMap = dbData['additionalElements'] != null
        ? mapFromDBData(jsonDecode(dbData['additionalElements']))
        : null;
    whenDeckConsistsOfXCards = dbData['whenDeckConsistsOfXCards'] != ''
        ? HandModel.whenDeckConsistsOfXCardsFromJSON(
            jsonDecode(dbData['whenDeckConsistsOfXCards']))
        : null;
    whenDeckConsistsOfXCardsOfExpansionCount =
        dbData['whenDeckConsistsOfXCardsOfExpansionCount'];
  }

  HandDBModel.fromModel(HandModel model) {
    id = model.id;
    always = model.always;
    elementIdCountMap = model.elementIdCountMap;
    additionalElementIdCountMap = model.additionalElementIdCountMap;
    whenDeckConsistsOfXCards = model.whenDeckConsistsOfXCards;
    whenDeckConsistsOfXCardsOfExpansionCount =
        model.whenDeckConsistsOfXCardsOfExpansionCount;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'always': always ? 1 : 0,
        'elements': mapToDB(elementIdCountMap),
        'additionalElements': mapToDB(additionalElementIdCountMap),
        'whenDeckConsistsOfXCards': whenDeckConsistsOfXCards != null
            ? whenDeckConsistsOfXCardsToDB(whenDeckConsistsOfXCards!)
            : '',
        'whenDeckConsistsOfXCardsOfExpansionCount':
            whenDeckConsistsOfXCardsOfExpansionCount,
      };

  String? mapToDB(Map<String, int>? value) {
    Map<String, String> retMap = {};
    String? ret;
    if (value != null) {
      for (var valueKey in value.keys) {
        retMap['"$valueKey"'] = '"${value[valueKey]}"';
      }
      ret = retMap.toString();
    }
    return ret;
  }

  static Map<String, int> mapFromDBData(dynamic json) {
    Map<String, int> retMap = {};
    var jsonMap = Map<String, String>.from(json);
    for (var stringMapKey in jsonMap.keys) {
      retMap[stringMapKey] = int.parse(json[stringMapKey]);
    }
    return retMap;
  }

  String whenDeckConsistsOfXCardsToDB(Map<int, List<String>> value) {
    Map<String, List<String>> retMap = {};
    for (var valueKey in value.keys) {
      retMap['"$valueKey"'] = value[valueKey]!.map((e) => '"$e"').toList();
    }
    var ret = retMap.toString();
    ret.replaceAll("=", "-");
    return ret;
  }
}
