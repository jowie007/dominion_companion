import 'package:dominion_comanion/model/expansion/expansion_model.dart';

class ExpansionDBModel {
  late String id;
  late String name;
  late String version;
  late List<String> cardIds;
  late List<String> contentIds;
  late List<String> handMoneyCardIds;
  late List<String> handOtherCardIds;
  late List<String> handContentIds;
  late String? endId;

  ExpansionDBModel.fromDB(Map<String, dynamic> dbData) {
    id = dbData['id'].toString();
    name = dbData['name'].toString();
    version = dbData['version'].toString();
    cardIds = dbData['cardIds'] != '' ? dbData['cardIds'].split(',') : [];
    contentIds =
        dbData['contentIds'] != '' ? dbData['contentIds'].split(',') : [];
    handMoneyCardIds = dbData['handMoneyCardIds'] != ''
        ? dbData['handMoneyCardIds'].split(',')
        : [];
    handOtherCardIds = dbData['handOtherCardIds'] != ''
        ? dbData['handOtherCardIds'].split(',')
        : [];
    handContentIds = dbData['handContentIds'] != ''
        ? dbData['handContentIds'].split(',')
        : [];
    endId = dbData['endId'];
  }

  ExpansionDBModel.fromModel(ExpansionModel model) {
    id = model.id;
    name = model.name;
    version = model.version;
    cardIds = model.cards.map((data) => data.id).toList();
    contentIds = model.content.map((data) => data.id).toList();
    handMoneyCardIds = model.handMoneyCards.map((data) => data.id).toList();
    handOtherCardIds = model.handOtherCards.map((data) => data.id).toList();
    handContentIds = model.handContents.map((data) => data.id).toList();
    endId = model.end != null ? model.end!.id : null;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'version': version,
        'cardIds': cardIds.join(","),
        'contentIds': contentIds.join(","),
        'handMoneyCardIds': handMoneyCardIds.join(","),
        'handOtherCardIds': handOtherCardIds.join(","),
        'handContentIds': handContentIds.join(","),
        'endId': endId,
      };
}
