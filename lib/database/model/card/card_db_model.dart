import 'package:dominion_comanion/model/card/card_model.dart';
import 'package:dominion_comanion/model/card/card_type_enum.dart';

import 'card_cost_db_model.dart';
import 'card_type_db_enum.dart';

class CardDBModel {
  late String id;
  late String name;
  late List<CardTypeEnum> cardTypes;
  late CardCostDBModel cardCost;
  late String text;

  CardDBModel(this.id, this.name, this.cardTypes, this.cardCost, this.text);

  CardDBModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    cardTypes = json['cardType']
        .split(',')
        .map((value) => value.toString().trim() as CardTypeEnum);
    cardCost = CardCostDBModel(
        json['coin'] as int?, json['debt'] as int?, json['potion'] as int?);
    text = json['text'];
  }

  CardDBModel.fromModel(CardModel model) {
    id = model.id;
    name = model.name;
    cardTypes = model.cardTypes;
    cardCost = CardCostDBModel.fromModel(model.cardCost);
    text = model.text;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'cardType': cardTypes.join(","),
        /*'action': cardType.action,
        'attack': cardType.attack,
        'curse': cardType.curse,
        'duration': cardType.duration,
        'treasure': cardType.treasure,
        'victory': cardType.victory,*/
        'coin': cardCost.coin,
        'debt': cardCost.debt,
        'potion': cardCost.potion,
        'text': text,
      };
}
