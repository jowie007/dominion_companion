import 'dart:developer';

import 'package:dominion_comanion/database/model/hand/hand_db_model.dart';

class HandModel {
  late String id;
  late bool always;
  late Map<String, int>? elementIdCountMap;
  late Map<String, int>? additionalElementIdCountMap;
  late Map<int, List<String>>? whenDeckConsistsOfXCards;
  late int? whenDeckConsistsOfXCardsOfExpansionCount;

  HandModel.empty(this.id) {
    always = false;
    elementIdCountMap = null;
    additionalElementIdCountMap = null;
    whenDeckConsistsOfXCards = null;
    whenDeckConsistsOfXCardsOfExpansionCount = null;
  }

  HandModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    always = json['always'] ?? false;
    elementIdCountMap = json['elements'] != null
        ? Map<String, int>.from(json['elements'])
        : null;
    additionalElementIdCountMap = json['additionalElements'] != null
        ? Map<String, int>.from(json['additionalElements'])
        : null;
    whenDeckConsistsOfXCards = json['whenDeckConsistsOfXCards'] != null
        ? whenDeckConsistsOfXCardsFromJSON(json['whenDeckConsistsOfXCards'])
        : null;
    whenDeckConsistsOfXCardsOfExpansionCount =
        json['whenDeckConsistsOfXCardsOfExpansionCount'];
  }

  HandModel.fromDBModel(HandDBModel dbModel) {
    id = dbModel.id;
    always = dbModel.always;
    elementIdCountMap = dbModel.elementIdCountMap;
    additionalElementIdCountMap = dbModel.additionalElementIdCountMap;
    whenDeckConsistsOfXCards = dbModel.whenDeckConsistsOfXCards;
    whenDeckConsistsOfXCardsOfExpansionCount =
        dbModel.whenDeckConsistsOfXCardsOfExpansionCount;
  }

  String getExpansionId() {
    return id.split('-').first;
  }

  getAllElements() {
    var items = [];
    if (elementIdCountMap != null) {
      items.addAll(elementIdCountMap!.entries);
    }
    if (additionalElementIdCountMap != null) {
      items.addAll(additionalElementIdCountMap!.entries);
    }
    return items;
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
}
