import 'dart:convert';

/*class HandDBModel {
  late String id;
  late bool always;
  late Map<String, int> cardIdsAndCount;
  late Map<String, int> additionalCardIdsAndCount;
  late Map<String, int> contentIdsAndCount;
  late Map<String, int> additionalContentIdsAndCount;

  HandDBModel.fromDB(Map<String, dynamic> dbData) {
    id = dbData['id'];
    always = dbData['always'] != null ? dbData['always'] > 0 : false;
    whenDeckConsistsOfXHandTypesOfExpansion =
    dbData['whenDeckConsistsOfXHandTypesOfExpansion'] != ''
        ? HandModel.whenDeckConsistsOfXHandTypesOfExpansionFromJSON(
        jsonDecode(dbData['whenDeckConsistsOfXHandTypesOfExpansion']))
        : null;
  }

  HandDBModel.fromModel(HandModel model) {
    id = model.id;
    name = model.name;
    always = model.always;
    whenDeckConsistsOfXHandTypesOfExpansion =
        model.whenDeckConsistsOfXHandTypesOfExpansion;
    setId = model.setId;
    parentId = model.parentId;
    relatedHandIds = model.relatedHandIds;
    invisible = model.invisible;
    handTypes = model.handTypes;
    handCost = HandCostDBModel.fromModel(model.handCost);
    text = model.text;
    count = model.count;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'always': always,
    'whenDeckConsistsOfXHandTypesOfExpansion':
    whenDeckConsistsOfXHandTypesOfExpansion != null
        ? whenDeckConsistsOfXHandTypesOfExpansionToDB(
        whenDeckConsistsOfXHandTypesOfExpansion!)
        : '',
    'setId': setId,
    'parentId': parentId,
    'relatedHandIds': relatedHandIds.join(','),
    'invisible': invisible ? 1 : 0,
    'handTypes': handTypes
        .map((e) =>
    e.toString().split('.')[e.toString().split('.').length - 1])
        .join(","),
    'coin': handCost.coin,
    'debt': handCost.debt,
    'potion': handCost.potion,
    'text': text,
    'count': count.isNotEmpty ? count.join(',') : null,
  };

  String whenDeckConsistsOfXHandTypesOfExpansionToDB(
      Map<int, List<List<HandTypeEnum>>> value) {
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
}*/
