import 'package:dominion_comanion/database/model/card/card_db_model.dart';

import 'card_cost_model.dart';
import 'card_type_enum.dart';

class CardModel {
  late String id;
  late String name;
  late bool always;
  late String setId;
  late String parentId;
  late List<String> relatedCardIds;
  late bool invisible;
  late List<CardTypeEnum> cardTypes;
  late CardCostModel cardCost;
  late String text;
  late List<String> count;

  CardModel(this.id, this.name, this.cardTypes, this.cardCost, this.text);

  CardModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    always = json['always'] ?? false;
    setId = json['setId'] ?? '';
    parentId = json['parentId'] ?? '';
    relatedCardIds = json['relatedCardIds'] != null
        ? json['relatedCardIds'].toString().split(',')
        : List.empty();
    invisible = json['invisible'] ?? false;
    cardTypes = List<CardTypeEnum>.from(json['cardTypes'].split(',').map(
        (value) => (CardTypeEnum.values.firstWhere((e) =>
            e.toString() == 'CardTypeEnum.${value.toString().trim()}'))));
    cardCost = CardCostModel.fromJson(json['cardCost']);
    text = json['text'] ?? '';
    count = json['count'] != null
        ? List<String>.from(json['count'].split(','))
        : [];
  }

  CardModel.fromDBModel(CardDBModel dbModel) {
    id = dbModel.id;
    name = dbModel.name;
    always = dbModel.always;
    setId = dbModel.setId;
    parentId = dbModel.parentId;
    relatedCardIds = dbModel.relatedCardIds;
    invisible = dbModel.invisible;
    cardTypes = dbModel.cardTypes;
    cardCost = CardCostModel.fromDBModel(dbModel.cardCost);
    text = dbModel.text;
    count = dbModel.count;
  }

  static String getCardTypesString(List<CardTypeEnum> cardTypes) {
    String fileName = cardTypes
        .map((e) =>
    e.name.substring(0, 1).toUpperCase() +
        e.name.substring(1, e.name.length).toUpperCase())
        .join("-");
    return fileName;
  }
}
