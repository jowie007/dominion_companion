import 'package:dominion_comanion/model/card/card_model.dart';
import 'package:dominion_comanion/model/card/card_type_enum.dart';

import 'card_cost_db_model.dart';

class CardDBModel {
  late String id;
  late String name;
  late String setId;
  late String parentId;
  late List<String> relatedCardIds;
  late bool invisible;
  late List<CardTypeEnum> cardTypes;
  late CardCostDBModel cardCost;
  late String text;

  CardDBModel(this.id, this.name, this.setId, this.parentId, this.cardTypes,
      this.cardCost, this.text);

  CardDBModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    setId = json['setId'] ?? '';
    parentId = json['parentId'] ?? '';
    relatedCardIds = json['relatedCardIds'] != null
        ? json['relatedCardIds'].toString().split(',')
        : List.empty();
    invisible = json['invisible'] != null ? json['invisible'] > 0 : false;
    cardTypes = List<CardTypeEnum>.from(json['cardTypes'].split(',').map(
        (value) => (CardTypeEnum.values.firstWhere((e) =>
            e.toString() == 'CardTypeEnum.${value.toString().trim()}'))));
    cardCost = CardCostDBModel(json['coin'].toString(), json['debt'].toString(),
        json['potion'].toString());
    text = json['text'] ?? '';
  }

  CardDBModel.fromModel(CardModel model) {
    id = model.id;
    name = model.name;
    setId = model.setId;
    parentId = model.parentId;
    relatedCardIds = model.relatedCardIds;
    invisible = model.invisible;
    cardTypes = model.cardTypes;
    cardCost = CardCostDBModel.fromModel(model.cardCost);
    text = model.text;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'setId': setId,
        'parentId': parentId,
        'relatedCardIds': relatedCardIds.join(','),
        'invisible': invisible ? 1 : 0,
        'cardTypes': cardTypes
            .map((e) =>
                e.toString().split('.')[e.toString().split('.').length - 1])
            .join(","),
        'coin': cardCost.coin,
        'debt': cardCost.debt,
        'potion': cardCost.potion,
        'text': text,
      };
}
