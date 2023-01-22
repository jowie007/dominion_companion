import 'dart:developer';

import 'package:dominion_comanion/database/model/card/card_db_model.dart';

import 'card_cost_model.dart';
import 'card_type_enum.dart';

class CardModel {
  late String id;
  late String name;
  late String setId;
  late String parentId;
  late List<String> relatedCardIds;
  late bool invisible;
  late List<CardTypeEnum> cardTypes;
  late CardCostModel cardCost;
  late String text;

  CardModel(this.id, this.name, this.cardTypes, this.cardCost, this.text);

  CardModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    setId = json['setId'] ?? '';
    parentId = json['parentId'] ?? '';
    relatedCardIds = json['relatedCardIds'] != null
        ? json['relatedCardIds'].toString().split(',')
        : List.empty();
    invisible = json['invisible'] != null ? json['invisible'] > 0 : false;
    log(json.toString(), name: 'my.app.category');
    cardTypes = List<CardTypeEnum>.from(json['cardTypes'].split(',').map(
        (value) => (CardTypeEnum.values.firstWhere((e) =>
            e.toString() == 'CardTypeEnum.${value.toString().trim()}'))));
    cardCost = CardCostModel.fromJson(json['cardCost']);
    text = json['text'] ?? '';
  }

  CardModel.fromDBModel(CardDBModel dbModel) {
    id = dbModel.id;
    name = dbModel.name;
    setId = dbModel.setId;
    parentId = dbModel.parentId;
    relatedCardIds = dbModel.relatedCardIds;
    invisible = dbModel.invisible;
    cardTypes = dbModel.cardTypes;
    cardCost = CardCostModel.fromDBModel(dbModel.cardCost);
    text = dbModel.text;
  }
}
