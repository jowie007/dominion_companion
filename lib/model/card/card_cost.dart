class CardCost {
  final int coin;
  final int pot;

  CardCost(this.coin, this.pot);

  Map<String, dynamic> toJson() => {
        'coin': coin,
        'pot': pot,
      };
}