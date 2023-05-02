import 'dart:convert';

import 'package:dominion_comanion/database/helpers/converters.dart';
import 'package:dominion_comanion/model/hand/hand_model.dart';

class HandDBModel {
  late String id;
  late bool always;
  late Map<String, int>? elementIdCountMap;
  late Map<String, List<String>>? elementsReplaceMap;
  late Map<String, int>? additionalElementIdCountMap;
  late Map<int, List<String>>? whenDeckConsistsOfXCards;
  late int? whenDeckConsistsOfXCardsOfExpansionCount;

  HandDBModel.fromDB(Map<String, dynamic> dbData) {
    id = dbData['id'];
    always = dbData['always'] != null ? dbData['always'] > 0 : false;
    elementIdCountMap = dbData['elements'] != null
        ? Converters.stringIntMapFromJSON(jsonDecode(dbData['elements']))
        : null;
    elementsReplaceMap = dbData['elementsReplace'] != null
        ? Converters.stringStringListMapFromJSON(
            jsonDecode(dbData['elementsReplace']))
        : null;
    additionalElementIdCountMap = dbData['additionalElements'] != null
        ? Converters.stringIntMapFromJSON(
            jsonDecode(dbData['additionalElements']))
        : null;
    whenDeckConsistsOfXCards = dbData['whenDeckConsistsOfXCards'] != ''
        ? Converters.intStringListMapFromJSON(
            jsonDecode(dbData['whenDeckConsistsOfXCards']))
        : null;
    whenDeckConsistsOfXCardsOfExpansionCount =
        dbData['whenDeckConsistsOfXCardsOfExpansionCount'];
  }

  HandDBModel.fromModel(HandModel model) {
    id = model.id;
    always = model.always;
    elementIdCountMap = model.elementIdCountMap;
    elementsReplaceMap = model.elementsReplaceMap;
    additionalElementIdCountMap = model.additionalElementIdCountMap;
    whenDeckConsistsOfXCards = model.whenDeckConsistsOfXCards;
    whenDeckConsistsOfXCardsOfExpansionCount =
        model.whenDeckConsistsOfXCardsOfExpansionCount;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'always': always ? 1 : 0,
        'elements': Converters.stringIntMapToDB(elementIdCountMap),
        'elementsReplace': elementsReplaceMap != null
            ? jsonEncode(elementsReplaceMap!).toString()
            : null,
        'additionalElements':
            Converters.stringIntMapToDB(additionalElementIdCountMap),
        'whenDeckConsistsOfXCards': whenDeckConsistsOfXCards != null
            ? Converters.intStringListMapToDB(whenDeckConsistsOfXCards!)
            : '',
        'whenDeckConsistsOfXCardsOfExpansionCount':
            whenDeckConsistsOfXCardsOfExpansionCount,
      };
}
