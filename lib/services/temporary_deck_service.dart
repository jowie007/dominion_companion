import 'package:dominion_companion/database/model/deck/deck_db_model.dart';
import 'package:dominion_companion/model/card/card_model.dart';
import 'package:dominion_companion/model/card/card_type_enum.dart';
import 'package:dominion_companion/model/card/card_type_infos.dart';
import 'package:dominion_companion/model/deck/deck_model.dart';
import 'package:dominion_companion/services/card_service.dart';
import 'package:dominion_companion/services/deck_service.dart';

class TemporaryDeckService {
  final DeckService _deckService = DeckService();
  final CardService _cardService = CardService();
  late Future<DeckModel> temporaryDeck;
  late List<String> morePossibleCardIds;
  bool saved = false;

  static final TemporaryDeckService _temporaryDeckService =
      TemporaryDeckService._internal();

  factory TemporaryDeckService() {
    return _temporaryDeckService;
  }

  TemporaryDeckService._internal();

  Future<void> createTemporaryDBDeck(
      String name, List<String> cardIds, bool cardLimit) async {
    temporaryDeck = createTemporaryDeck(name, cardIds, cardLimit);
  }

  Future<DeckModel> createTemporaryDeck(
      String name, List<String> cardIds, bool cardLimit) async {
    List<String> cardIdsFiltered = await filterCards(cardIds, cardLimit);
    morePossibleCardIds =
        cardIds.where((element) => !cardIdsFiltered.contains(element)).toList();
    morePossibleCardIds.shuffle();
    return _deckService.deckFromDBModel(DeckDBModel(
        null, name, null, cardIdsFiltered, DateTime.now(), null, null));
  }

  Future<bool> replaceCardFromTemporaryDeck(String cardId) async {
    if (morePossibleCardIds.isEmpty) {
      return false;
    }
    DeckModel oldDeck = await temporaryDeck;
    List<String> newCardIds = oldDeck.cards
        .where((element) => element.id != cardId)
        .map((e) => e.id)
        .toList();
    newCardIds.add(morePossibleCardIds.removeLast());
    temporaryDeck = _deckService.deckFromDBModel(DeckDBModel(
        null, "", null, newCardIds, oldDeck.creationDate, null, null));
    return true;
  }

  Future<List<String>> filterCards(List<String> cardIds, bool cardLimit) async {
    if (!cardLimit) {
      return cardIds;
    }
    const max = 2;
    cardIds.shuffle();
    List<CardModel> cards = await _cardService.getCardsByCardIds(cardIds);
    CardModel? wegCard;
    for (var card in cards) {
      if (card.cardTypes.contains(CardTypeEnum.weg)) {
        wegCard = card;
        break;
      }
    }
    cards = cards
        .where((card) => !card.cardTypes.contains(CardTypeEnum.weg))
        .toList();
    List<CardModel> normalCards = [...cards];
    List<CardModel> hCards = [];
    var count = 0;
    for (var card in cards) {
      for (var element in horizontalCards) {
        if (card.cardTypes.contains(element)) {
          normalCards.remove(card);
          if (count < max) {
            hCards.add(card);
            count++;
          }
        }
      }
    }
    /*for (var element in horizontalCards) {
      var count = 0;
      for (var card in cards) {
        if (card.cardTypes.contains(element)) {
          normalCards.remove(card);
          if (count < max) {
            hCards.add(card);
            count++;
          }
        }
      }
    }*/
    var ret = [...hCards, ...normalCards.take(DeckService.deckSize).toList()]
        .map((card) => card.id)
        .toList();
    if (wegCard != null) {
      ret.add(wegCard.id);
    }
    return ret;
  }
}
