import 'dart:io';

import 'package:dominion_companion/model/card/card_model.dart';
import 'package:dominion_companion/model/content/content_model.dart';
import 'package:dominion_companion/model/end/end_model.dart';
import 'package:dominion_companion/model/hand/hand_model.dart';

class DeckModel {
  late int? id;
  late String name;
  late File? image;
  late DateTime creationDate;
  late DateTime? editDate;
  late int? rating;
  late List<CardModel> cards;
  late List<CardModel>? additionalCards;
  late List<ContentModel> content;
  late HandModel handMoneyCards;
  late HandModel handOtherCards;
  late HandModel handContents;
  late EndModel end;

  DeckModel(
      this.id,
      this.name,
      this.image,
      this.creationDate,
      this.editDate,
      this.rating,
      this.cards,
      this.additionalCards,
      this.content,
      this.handMoneyCards,
      this.handOtherCards,
      this.handContents,
      this.end);

  List<CardModel> getAllCards() {
    var allCards = [...cards];
    if (additionalCards != null) {
      allCards.addAll(additionalCards!);
    }
    allCards.sort((a, b) => CardModel.sortCardComparisonDeck(a, b));
    return allCards;
  }
}
