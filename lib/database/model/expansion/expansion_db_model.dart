import 'package:dominion_comanion/model/expansion/expansion_model.dart';

class ExpansionDBModel {
  late String id;
  late String name;
  late String version;
  late List<String> cardIds;
  late List<String> contentIds;
  late String? handId;
  late String? endId;

  ExpansionDBModel.fromDB(Map<String, dynamic> dbData) {
    id = dbData['id'].toString();
    name = dbData['name'].toString();
    version = dbData['version'].toString();
    cardIds = dbData['cardIds'] != '' ? dbData['cardIds'].split(',') : [];
    contentIds =
        dbData['contentIds'] != '' ? dbData['contentIds'].split(',') : [];
    handId = dbData['handId'];
    endId = dbData['endId'];
  }

  ExpansionDBModel.fromModel(ExpansionModel model) {
    id = model.id;
    name = model.name;
    version = model.version;
    cardIds = model.cards.map((data) => data.id).toList();
    contentIds = model.content.map((data) => data.id).toList();
    handId = model.hand != null ? model.hand!.id : null;
    endId = model.end != null ? model.end!.id : null;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'version': version,
        'cardIds': cardIds.join(","),
        'contentIds': contentIds.join(","),
        'handId': handId,
        'endId': endId,
      };
}
