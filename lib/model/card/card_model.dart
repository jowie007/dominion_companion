import 'card_cost_model.dart';
import 'card_type_model.dart';

class CardModel {
  late String id;
  late String name;
  late CardTypeModel cardType;
  late CardCostModel cardCost;
  late String text;

  CardModel(this.id, this.name, this.cardType, this.cardCost, this.text);

  CardModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    cardType = CardTypeModel.fromJson(json['cardType']);
    cardCost = CardCostModel.fromJson(json['cardCost']);
    text = json['text'];
  }
}
