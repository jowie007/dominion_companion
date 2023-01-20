import 'package:dominion_comanion/model/card/card_model.dart';

import 'card_cost_db_model.dart';
import 'card_type_db_model.dart';

class CardDBModel {
  late String id;
  late String name;
  late CardTypeDBModel cardType;
  late CardCostDBModel cardCost;
  late String text;

  CardDBModel(this.id, this.name, this.cardType, this.cardCost, this.text);

  CardDBModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    cardType = CardTypeDBModel(json['action'], json['attack'], json['curse'],
        json['duration'], json['treasure'], json['victory']);
    cardCost = CardCostDBModel(json['coin'], json['debt'], json['potion']);
    text = json['text'];
  }

  CardDBModel.fromModel(CardModel model) {
    id = model.id;
    name = model.name;
    cardType = CardTypeDBModel.fromModel(model.cardType);
    cardCost = CardCostDBModel.fromModel(model.cardCost);
    text = model.text;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'action': cardType.action,
        'attack': cardType.attack,
        'curse': cardType.curse,
        'duration': cardType.duration,
        'treasure': cardType.treasure,
        'victory': cardType.victory,
        'coin': cardCost.coin,
        'debt': cardCost.debt,
        'potion': cardCost.potion,
        'text': text,
      };
}
