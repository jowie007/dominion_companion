import 'package:dominion_comanion/model/card/card_cost_model.dart';

class CardCostDBModel {
  late int? coin;
  late int? debt;
  late int? potion;

  CardCostDBModel(this.coin, this.debt, this.potion);

  CardCostDBModel.fromModel(CardCostModel model) {
    coin = model.coin;
    debt = model.debt;
    potion = model.potion;
  }

  Map<String, dynamic> toJson() => {
        'coin': coin,
        'debt': debt,
        'potion': potion,
      };
}
