import 'dart:developer';

import 'package:dominion_comanion/model/card/card_model.dart';
import 'package:dominion_comanion/model/content/content_model.dart';
import 'package:dominion_comanion/model/end/end_model.dart';
import 'package:dominion_comanion/model/hand/hand_model.dart';

class DeckModel {
  late String name;
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

  DeckModel(this.name, this.creationDate, this.editDate, this.rating, this.cards, this.additionalCards, this.content,
      this.handMoneyCards, this.handOtherCards, this.handContents, this.end);

  List<CardModel> getAllCards() {
    var allCards = [...cards];
    allCards.sort((a, b) => CardModel.sortCardComparisonDeck(a, b));
    if (additionalCards != null) {
      var sortedAdditionalCards = [...additionalCards!];
      sortedAdditionalCards.sort((a, b) => CardModel.sortCardComparisonDeck(a, b));
      allCards.addAll(sortedAdditionalCards);
    }
    return allCards;
  }
}
