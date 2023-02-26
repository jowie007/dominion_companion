import 'package:dominion_comanion/model/expansion/expansion_model.dart';

class ExpansionDBModel {
  late String id;
  late String name;
  late String version;
  late List<String> cardIds;
  late List<String> contentIds;

  ExpansionDBModel(this.id, this.name, this.version, this.cardIds);

  ExpansionDBModel.fromDB(Map<String, dynamic> dbData) {
    id = dbData['id'].toString();
    name = dbData['name'].toString();
    version = dbData['version'].toString();
    cardIds = dbData['cardIds'] != '' ? dbData['cardIds'].split(',') : [];
    contentIds =
        dbData['contentIds'] != '' ? dbData['contentIds'].split(',') : [];
  }

  ExpansionDBModel.fromModel(ExpansionModel model) {
    id = model.id;
    name = model.name;
    version = model.version;
    cardIds = model.cards.map((data) => data.id).toList();
    contentIds = model.content.map((data) => data.id).toList();
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'version': version,
        'cardIds': cardIds.join(","),
        'contentIds': contentIds.join(","),
      };
}
