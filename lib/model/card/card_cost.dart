class CardCost {
  final int? coin;
  final int? debt;
  final int? potion;

  CardCost(this.coin, this.debt, this.potion);

  Map<String, dynamic> toJson() => {
        'coin': coin,
        'debt': debt,
        'potion': potion,
      };
}
