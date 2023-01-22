import 'package:dominion_comanion/model/expansion/expansion_model.dart';

class ExpansionDBModel {
  late String id;
  late String name;
  late String version;
  late List<String> cardIds;

  ExpansionDBModel(this.id, this.name, this.version, this.cardIds);

  ExpansionDBModel.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    name = json['name'].toString();
    version = json['version'].toString();
    cardIds = json['cardIds'].split(',');
  }

  ExpansionDBModel.fromModel(ExpansionModel model) {
    id = model.id;
    name = model.name;
    version = model.version;
    cardIds = model.cards.map((data) => data.id).toList();
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'version': version,
        'cardIds': cardIds.join(","),
      };
}
