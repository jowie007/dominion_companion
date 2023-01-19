import 'package:dominion_comanion/model/card/card_cost.dart';
import 'package:dominion_comanion/model/card/card_type.dart';

class CardModel {
  final String id;
  final String name;
  final String expansionId;
  final CardType cardType;
  final CardCost cardCost;
  final String text;
  final bool selected;

  CardModel(this.id, this.name, this.expansionId, this.cardType, this.cardCost,
      this.text, this.selected);

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'expansionId': expansionId,
        'cardType': cardType.toJson(),
        'cardCost': cardCost.toJson(),
        'text': text,
        'selected': selected,
      };
}
