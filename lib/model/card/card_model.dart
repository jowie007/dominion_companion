import 'package:dominion_comanion/model/card/card_cost.dart';
import 'package:dominion_comanion/model/card/card_type.dart';
import 'package:dominion_comanion/model/expansion/expansion_model.dart';

class Card {
  final int id;
  final String name;
  final int expansionId;
  final CardType cardType;
  final CardCost cardCost;
  final String text;

  Card(this.id, this.name, this.expansionId, this.cardType, this.cardCost, this.text);

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'expansionId': expansionId,
    'cardType': cardType.toJson(),
    'cardCost': cardCost.toJson(),
    'text': text,
  };
}