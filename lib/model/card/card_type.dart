class CardType {
  final bool action;
  final bool attack;
  final bool curse;
  final bool duration;
  final bool treasure;
  final bool victory;

  CardType(this.action, this.attack, this.curse, this.duration, this.treasure, this.victory);

  Map<String, dynamic> toJson() => {
    'action': action,
    'attack': attack,
    'curse': curse,
    'duration': duration,
    'treasure': treasure,
    'victory': victory,
  };
}