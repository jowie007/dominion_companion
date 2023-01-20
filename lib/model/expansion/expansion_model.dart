import 'package:dominion_comanion/database/model/expansion/expansion_db_model.dart';
import 'package:dominion_comanion/model/card/card_model.dart';

class ExpansionModel {
  late String id;
  late String name;
  late String version;
  late List<CardModel> cards;

  ExpansionModel(this.id, this.name, this.version, this.cards);

  ExpansionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    version = json['version'];
    cards = (json['cards'] as List)
        .map((data) => CardModel.fromJson(data))
        .toList();
  }

  ExpansionModel.fromDBModelAndCards(
      ExpansionDBModel dbModel, this.cards) {
    id = dbModel.id;
    name = dbModel.name;
    version = dbModel.version;
  }
}
