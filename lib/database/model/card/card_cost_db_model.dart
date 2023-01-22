import 'package:dominion_comanion/model/card/card_cost_model.dart';

class CardCostDBModel {
  late String coin;
  late String debt;
  late String potion;

  CardCostDBModel(this.coin, this.debt, this.potion);

  CardCostDBModel.fromModel(CardCostModel model) {
    coin = model.coin;
    debt = model.debt;
    potion = model.potion;
  }

  CardCostDBModel.fromJson(Map<String, dynamic> json) {
    coin = json['coin'] != null ? json['coin'].toString() : '';
    debt = json['debt'] != null ? json['debt'].toString() : '';
    potion = json['potion'] != null ? json['potion'].toString() : '';
  }

  Map<String, dynamic> toJson() => {
        'coin': coin,
        'debt': debt,
        'potion': potion,
      };
}
