import 'package:dominion_companion/database/model/expansion/expansion_db_model.dart';
import 'package:dominion_companion/model/card/card_model.dart';
import 'package:dominion_companion/model/content/content_model.dart';
import 'package:dominion_companion/model/end/end_model.dart';
import 'package:dominion_companion/model/hand/hand_model.dart';

class ExpansionModel {
  late String id;
  late String name;
  late String version;
  late int priority;
  late List<CardModel> cards;
  late List<ContentModel> content;
  late List<HandModel> handMoneyCards;
  late List<HandModel> handOtherCards;
  late List<HandModel> handContents;
  late EndModel? end;

  ExpansionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    name = json['name'];
    version = json['version'].toString();
    try {
      priority = int.parse(json['priority']);
    } catch (e) {
      priority = 0;
    }
    cards = (json['cards'] as List)
        .map((data) => CardModel.fromJson(data))
        .toList();
    content = json['content'] != null
        ? (json['content'] as List)
            .map((data) => ContentModel.fromJson(data))
            .toList()
        : [];
    handMoneyCards = json['handMoneyCards'] != null
        ? (json['handMoneyCards'] as List)
            .map((data) => HandModel.fromJson(data))
            .toList()
        : [];
    handOtherCards = json['handOtherCards'] != null
        ? (json['handOtherCards'] as List)
            .map((data) => HandModel.fromJson(data))
            .toList()
        : [];
    handContents = json['handContents'] != null
        ? (json['handContents'] as List)
            .map((data) => HandModel.fromJson(data))
            .toList()
        : [];
    end = json['end'] != null ? EndModel.fromJson(json['end']) : null;
  }

  ExpansionModel.fromDBModelAndCards(ExpansionDBModel dbModel, this.cards) {
    id = dbModel.id;
    name = dbModel.name;
    version = dbModel.version;
    priority = dbModel.priority;
  }

  ExpansionModel.fromDBModelAndAdditional(
      ExpansionDBModel dbModel,
      this.cards,
      this.content,
      this.handMoneyCards,
      this.handOtherCards,
      this.handContents,
      this.end) {
    id = dbModel.id;
    name = dbModel.name;
    version = dbModel.version;
    priority = dbModel.priority;
  }

  getCardIds() {
    return cards.map((card) => card.id).toList();
  }

  getVisibleCardsIds() {
    return cards
        .where((card) => !card.invisible)
        .map((card) => card.id)
        .toList();
  }

  getVisibleCards() {
    return cards.where((card) => !card.invisible).toList();
  }

  getFullName() {
    return "$name - $version";
  }
}
