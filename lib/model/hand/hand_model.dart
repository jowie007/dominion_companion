import 'dart:developer';

import 'package:dominion_comanion/database/model/hand/hand_db_model.dart';

class HandModel {
  late String id;
  late bool always;
  late Map<String, int>? cardIdCountMap;
  late Map<String, int>? additionalCardIdCountMap;
  late Map<String, int>? contentIdCountMap;
  late Map<String, int>? additionalContentIdsCountMap;
  late Map<int, List<String>>? whenDeckConsistsOfXCards;
  late int? whenDeckConsistsOfXCardsOfExpansionCount;

  HandModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    always = json['always'] ?? false;
    cardIdCountMap =
        json['cards'] != null ? Map<String, int>.from(json['cards']) : null;
    additionalCardIdCountMap = json['additionalCards'] != null
        ? Map<String, int>.from(json['additionalCards'])
        : null;
    contentIdCountMap =
        json['content'] != null ? Map<String, int>.from(json['content']) : null;
    additionalContentIdsCountMap = json['additionalContent'] != null
        ? Map<String, int>.from(json['additionalContent'])
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
    cardIdCountMap = dbModel.cardIdCountMap;
    additionalCardIdCountMap = dbModel.additionalCardIdCountMap;
    contentIdCountMap = dbModel.contentIdCountMap;
    additionalContentIdsCountMap = dbModel.additionalContentIdsCountMap;
    whenDeckConsistsOfXCards = dbModel.whenDeckConsistsOfXCards;
    whenDeckConsistsOfXCardsOfExpansionCount =
        dbModel.whenDeckConsistsOfXCardsOfExpansionCount;
  }

  String getExpansionId() {
    return id.split('-').first;
  }

  getAllCards() {
    var items = [];
    if (cardIdCountMap != null) {
      items.addAll(cardIdCountMap!.entries);
    }
    if (additionalCardIdCountMap != null) {
      items.addAll(additionalCardIdCountMap!.entries);
    }
    return items;
  }

  getAllContents() {
    var items = [];
    if (contentIdCountMap != null) {
      items.addAll(contentIdCountMap!.entries);
    }
    if (additionalContentIdsCountMap != null) {
      items.addAll(additionalContentIdsCountMap!.entries);
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
