import 'dart:developer';

import 'package:dominion_comanion/model/card/card_model.dart';
import 'package:dominion_comanion/model/content/content_model.dart';
import 'package:dominion_comanion/model/end/end_model.dart';
import 'package:dominion_comanion/model/hand/hand_model.dart';

class DeckModel {
  late String name;
  late List<CardModel> cards;
  late List<CardModel>? additionalCards;
  late ContentModel? content;
  late HandModel hand;
  late EndModel end;
  final sortTypeOrder = [
    ["aktion", "aktion-angriff", "aktion-reaktion"],
    ["punkte"],
    ["geld"],
    ["fluch"]
  ];

  DeckModel(this.name, this.cards, this.additionalCards, this.content,
      this.hand, this.end);

  List<CardModel> getAllCards() {
    var allCards = [...cards];
    allCards.sort((a, b) => sortCardComparison(a, b));
    if (additionalCards != null) {
      var sortedAdditionalCards = [...additionalCards!];
      sortedAdditionalCards!.sort((a, b) => sortCardComparison(a, b));
      allCards.addAll(sortedAdditionalCards);
    }
    return allCards;
  }

  int sortCardComparison(CardModel card1, CardModel card2) {
    final cardTypes1 =
    CardModel.getCardTypesString(card1.cardTypes).toLowerCase();
    final cardTypes2 =
    CardModel.getCardTypesString(card2.cardTypes).toLowerCase();
    var cardPosition1 = 0;
    var cardPosition2 = 0;
    sortTypeOrder.asMap().forEach((index, value) =>
    {
      if (value.contains(cardTypes1)) {cardPosition1 = index},
      if (value.contains(cardTypes2)) {cardPosition2 = index}
    });
    if (cardPosition1 == cardPosition2) {
      if (card1.cardCost.coin == card2.cardCost.coin) {
        if (card1.cardCost.potion == card2.cardCost.potion) {
          if (card1.cardCost.debt == card2.cardCost.debt) {
            return card1.name.compareTo(card2.name);
          }
          return compareStringNumbers(card1.cardCost.debt, card2.cardCost.debt);
        }
        return compareStringNumbers(
            card1.cardCost.potion, card2.cardCost.potion);
      }
      return compareStringNumbers(card1.cardCost.coin, card2.cardCost.coin);
    }
    return cardPosition1 > cardPosition2 ? 1 : -1;
  }

  int compareStringNumbers(String stringNumber1, String stringNumber2) {
    var number1 = int.parse(stringNumber1
        .split(RegExp(r'\D'))
        .first);
    var number2 = int.parse(stringNumber2
        .split(RegExp(r'\D'))
        .first);
    var ret = 0;
    if (number1 < number2) {
      ret = -1;
    } else if (number1 > number2) {
      ret = 1;
    }
    return ret;
  }
}
