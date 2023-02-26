import 'package:dominion_comanion/database/model/expansion/expansion_db_model.dart';
import 'package:dominion_comanion/model/card/card_model.dart';
import 'package:dominion_comanion/model/content/content_model.dart';

class ExpansionModel {
  late String id;
  late String name;
  late String version;
  late List<CardModel> cards;
  late List<ContentModel> content;

  ExpansionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    name = json['name'];
    version = json['version'].toString();
    cards = (json['cards'] as List)
        .map((data) => CardModel.fromJson(data))
        .toList();
    content = json['content'] != null
        ? (json['content'] as List)
            .map((data) => ContentModel.fromJson(data))
            .toList()
        : [];
  }

  ExpansionModel.fromDBModelAndCards(ExpansionDBModel dbModel, this.cards) {
    id = dbModel.id;
    name = dbModel.name;
    version = dbModel.version;
  }

  ExpansionModel.fromDBModelAndCardsAndContent(
      ExpansionDBModel dbModel, this.cards, this.content) {
    id = dbModel.id;
    name = dbModel.name;
    version = dbModel.version;
  }
}
