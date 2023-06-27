import 'dart:convert';

import 'package:dominion_companion/helpers/converters.dart';
import 'package:dominion_companion/model/content/content_model.dart';

class ContentDBModel {
  late String id;
  late String name;
  late bool always;
  late Map<int, List<String>>? whenDeckConsistsOfXCards;
  late List<String> count;

  ContentDBModel.fromDB(Map<String, dynamic> dbData) {
    id = dbData['id'];
    name = dbData['name'];
    always = dbData['always'] != null ? dbData['always'] > 0 : false;
    whenDeckConsistsOfXCards = dbData['whenDeckConsistsOfXCards'] != ''
        ? ContentModel.whenDeckConsistsOfXCardsFromJSON(
            jsonDecode(dbData['whenDeckConsistsOfXCards']))
        : null;
    count = dbData['count'] != null
        ? List<String>.from(dbData['count'].split(','))
        : ["0,2,3,4,5,6"];
  }

  ContentDBModel.fromModel(ContentModel model) {
    id = model.id;
    name = model.name;
    always = model.always;
    whenDeckConsistsOfXCards = model.whenDeckConsistsOfXCards;
    count = model.count;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'always': always ? 1 : 0,
        'whenDeckConsistsOfXCards': whenDeckConsistsOfXCards != null
            ? Converters.intStringListMapToDB(whenDeckConsistsOfXCards!)
            : '',
        'count': count.isNotEmpty
            ? count.join(',')
            : ["0", "2", "3", "4", "5", "6"].join(','),
      };
}
