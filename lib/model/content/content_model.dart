import 'package:dominion_comanion/database/model/content/content_db_model.dart';

class ContentModel {
  late String id;
  late String name;
  late bool always;
  late Map<int, List<String>>? whenDeckConsistsOfXCards;
  late List<String> count;

  ContentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    always = json['always'] ?? false;
    whenDeckConsistsOfXCards = json['whenDeckConsistsOfXCards'] != null
        ? whenDeckConsistsOfXCardsFromJSON(json['whenDeckConsistsOfXCards'])
        : null;
    count = json['count'] != null
        ? List<String>.from(json['count'].split(','))
        : List.empty();
  }

  ContentModel.fromDBModel(ContentDBModel dbModel) {
    id = dbModel.id;
    name = dbModel.name;
    always = dbModel.always;
    whenDeckConsistsOfXCards = dbModel.whenDeckConsistsOfXCards;
    count = dbModel.count;
  }

  static Map<int, List<String>> whenDeckConsistsOfXCardsFromJSON(
      dynamic json) {
    Map<int, List<String>> retMap = {};
    var jsonMap = Map<String, List<dynamic>>.from(json);
    for (var stringMapKey in jsonMap.keys) {
      retMap[int.parse(stringMapKey)] =
          List<String>.from(json[stringMapKey]);
    }
    return retMap;
  }
}
