import 'package:dominion_comanion/model/card/card_model.dart';
import 'package:dominion_comanion/model/card/card_type_enum.dart';

import 'card_cost_db_model.dart';

class CardDBModel {
  late String id;
  late String name;
  late bool always;
  late int? whenDeckConsistsOfXCardsOfExpansion;
  late String setId;
  late String parentId;
  late List<String> relatedCardIds;
  late bool invisible;
  late List<CardTypeEnum> cardTypes;
  late CardCostDBModel cardCost;
  late String text;
  late List<String> count;

  CardDBModel(this.id, this.name, this.always, this.setId, this.parentId,
      this.cardTypes, this.cardCost, this.text, this.count);

  CardDBModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    always = json['always'] != null ? json['always'] > 0 : false;
    whenDeckConsistsOfXCardsOfExpansion =
        json['whenDeckConsistsOfXCardsOfExpansion'];
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
    count = json['count'] != null
        ? List<String>.from(json['count'].split(','))
        : List.empty();
  }

  CardDBModel.fromModel(CardModel model) {
    id = model.id;
    name = model.name;
    always = model.always;
    whenDeckConsistsOfXCardsOfExpansion =
        model.whenDeckConsistsOfXCardsOfExpansion;
    setId = model.setId;
    parentId = model.parentId;
    relatedCardIds = model.relatedCardIds;
    invisible = model.invisible;
    cardTypes = model.cardTypes;
    cardCost = CardCostDBModel.fromModel(model.cardCost);
    text = model.text;
    count = model.count;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'always': always,
        'whenDeckConsistsOfXCardsOfExpansion':
            whenDeckConsistsOfXCardsOfExpansion,
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
        'count': count.isNotEmpty ? count.join(',') : null,
      };
}
