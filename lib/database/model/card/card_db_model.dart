import 'card_cost_db_model.dart';
import 'card_type_db_model.dart';

class CardDBModel {
  final String id;
  final String name;
  final String expansionId;
  final CardTypeDBModel cardType;
  final CardCostDBModel cardCost;
  final String text;
  final bool selected;

  CardDBModel(this.id, this.name, this.expansionId, this.cardType, this.cardCost,
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
