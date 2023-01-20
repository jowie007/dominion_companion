import 'package:dominion_comanion/database/model/card/card_cost_db_model.dart';

class CardCostModel {
  late int? coin;
  late int? debt;
  late int? potion;

  CardCostModel(this.coin, this.debt, this.potion);

  CardCostModel.fromJson(Map<String, dynamic> json) {
    coin = json['coin'];
    debt = json['debt'];
    potion = json['potion'];
  }

  CardCostModel.fromDBModel(CardCostDBModel dbModel) {
    coin = dbModel.coin;
    debt = dbModel.debt;
    potion = dbModel.potion;
  }
}
