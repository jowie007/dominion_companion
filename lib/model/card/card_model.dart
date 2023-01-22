import 'package:dominion_comanion/database/model/card/card_db_model.dart';

import 'card_cost_model.dart';
import 'card_type_enum.dart';

class CardModel {
  late String id;
  late String name;
  late List<CardTypeEnum> cardTypes;
  late CardCostModel cardCost;
  late String text;

  CardModel(this.id, this.name, this.cardTypes, this.cardCost, this.text);

  CardModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    cardTypes = json['cardType'].split(',').map((value) => value.toString().trim() as CardTypeEnum);
    cardCost = CardCostModel.fromJson(json['cardCost']);
    text = json['text'];
  }

  CardModel.fromDBModel(CardDBModel dbModel) {
    id = dbModel.id;
    name = dbModel.name;
    cardTypes = dbModel.cardTypes;
    cardCost = CardCostModel.fromDBModel(dbModel.cardCost);
    text = dbModel.text;
  }
}
