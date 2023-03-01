import 'dart:convert';
import 'dart:developer';

import 'package:dominion_comanion/model/hand/hand_model.dart';

class HandDBModel {
  late String id;
  late bool always;
  late Map<String, int>? cardIdCountMap;
  late Map<String, int>? additionalCardIdCountMap;
  late Map<String, int>? contentIdCountMap;
  late Map<String, int>? additionalContentIdsCountMap;

  HandDBModel.fromDB(Map<String, dynamic> dbData) {
    id = dbData['id'];
    always = dbData['always'] != null ? dbData['always'] > 0 : false;
    cardIdCountMap = dbData['cards'] != null
        ? mapFromDBData(jsonDecode(dbData['cards']))
        : null;
    additionalCardIdCountMap = dbData['additionalCards'] != null
        ? mapFromDBData(jsonDecode(dbData['additionalCards']))
        : null;
    contentIdCountMap = dbData['content'] != null
        ? mapFromDBData(jsonDecode(dbData['content']))
        : null;
    additionalContentIdsCountMap = dbData['additionalContent'] != null
        ? mapFromDBData(jsonDecode(dbData['additionalContent']))
        : null;
  }

  HandDBModel.fromModel(HandModel model) {
    id = model.id;
    always = model.always;
    cardIdCountMap = model.cardIdCountMap;
    additionalCardIdCountMap = model.additionalCardIdCountMap;
    contentIdCountMap = model.contentIdCountMap;
    additionalContentIdsCountMap = model.additionalContentIdsCountMap;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'always': always,
        'cards': mapToDB(cardIdCountMap),
        'additionalCards': mapToDB(additionalCardIdCountMap),
        'content': mapToDB(contentIdCountMap),
        'additionalContent': mapToDB(additionalContentIdsCountMap)
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
}
