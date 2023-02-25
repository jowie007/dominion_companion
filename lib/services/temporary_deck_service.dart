import 'package:dominion_comanion/database/card_database.dart';
import 'package:dominion_comanion/model/card/card_model.dart';
import 'package:dominion_comanion/model/deck/deck_model.dart';
import 'package:dominion_comanion/services/card_service.dart';
import 'package:dominion_comanion/services/deck_service.dart';

class TemporaryDeckService {
  final DeckService _deckService = DeckService();
  final CardService _cardService = CardService();
  final CardDatabase _cardDatabase = CardDatabase();
  late Future<DeckModel> temporaryDeck;
  bool saved = false;

  static final TemporaryDeckService _temporaryDeckService =
      TemporaryDeckService._internal();

  factory TemporaryDeckService() {
    return _temporaryDeckService;
  }

  TemporaryDeckService._internal();

  Future<void> createTemporaryDeck(String name, List<String> cardIds) async {
    cardIds.shuffle();
    temporaryDeck = createTemporaryDeckAndExtendCards(name, cardIds);
  }

  Future<DeckModel> createTemporaryDeckAndExtendCards(
      String name, List<String> cardIds) async {
    var initialCardIds = cardIds.take(DeckService.deckSize).toList();

    var selectedCards = await Future.wait(initialCardIds
        .toList()
        .map((cardId) async =>
            CardModel.fromDBModel(await _cardDatabase.getCardById(cardId)))
        .toList());

    List<CardModel> alwaysCards = await Future.wait(
        (await _cardService.getAlwaysCards())
            .map((card) async => CardModel.fromDBModel(card)));
    List<CardModel> whenDeckConsistsOfXCardsCards = await Future.wait(
        (await _cardService.getWhenDeckConsistsOfXCardsOfExpansionCards())
            .map((card) async => CardModel.fromDBModel(card)));
    for (var whenDeckConsistsOfXCardsCard in whenDeckConsistsOfXCardsCards) {
      var expansionCardCount = 0;
      for (var selectedCard in selectedCards) {
        if (whenDeckConsistsOfXCardsCard.getCardExpansion() ==
            selectedCard.getCardExpansion()) {
          expansionCardCount++;
        }
      }
      if (expansionCardCount >=
          whenDeckConsistsOfXCardsCard.whenDeckConsistsOfXCardsOfExpansion!) {
        selectedCards.add(whenDeckConsistsOfXCardsCard);
      }
    }
    selectedCards.addAll(alwaysCards);
    return _deckService.deckFromNameAndCards(name, selectedCards);
  }
}
