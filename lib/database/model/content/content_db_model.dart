import 'dart:convert';

import 'package:dominion_comanion/model/content/content_model.dart';

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
        : List.empty();
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
        'always': always,
        'whenDeckConsistsOfXCards': whenDeckConsistsOfXCards != null
            ? whenDeckConsistsOfXCardsToDB(whenDeckConsistsOfXCards!)
            : '',
        'count': count.isNotEmpty ? count.join(',') : null,
      };

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
