import 'package:dominion_comanion/database/model/card/card_cost_db_model.dart';

class CardCostModel {
  late String coin;
  late String debt;
  late String potion;

  CardCostModel(this.coin, this.debt, this.potion);

  CardCostModel.fromJson(Map<String, dynamic>? json) {
    coin = json != null && json['coin'] != null ? json['coin'].toString() : '';
    debt = json != null && json['debt'] != null ? json['debt'].toString() : '';
    potion =
        json != null && json['potion'] != null ? json['potion'].toString() : '';
  }

  CardCostModel.fromDBModel(CardCostDBModel dbModel) {
    coin = dbModel.coin;
    debt = dbModel.debt;
    potion = dbModel.potion;
  }
}
