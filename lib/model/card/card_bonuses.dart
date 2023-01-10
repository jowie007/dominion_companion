class CardBonuses {
  final int action;
  final int buy;
  final int card;
  final int coin;
  final int vp;

  CardBonuses(this.action, this.buy, this.card, this.coin, this.vp);

  Map<String, dynamic> toJson() => {
    'action': action,
    'buy': buy,
    'card': card,
    'coin': coin,
    'vp': vp,
  };
}