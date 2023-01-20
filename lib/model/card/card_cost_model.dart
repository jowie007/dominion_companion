class CardCostModel {
  late int? coin;
  late int? debt;
  late int? potion;

  CardCostModel(this.coin, this.debt, this.potion);

  CardCostModel.fromJson(Map<String, dynamic> json) {
    coin = json['coin'];
    coin = json['debt'];
    coin = json['potion'];
  }
}
