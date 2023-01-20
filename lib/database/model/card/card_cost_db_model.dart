class CardCostDBModel {
  final int? coin;
  final int? debt;
  final int? potion;

  CardCostDBModel(this.coin, this.debt, this.potion);

  Map<String, dynamic> toJson() => {
        'coin': coin,
        'debt': debt,
        'potion': potion,
      };
}
