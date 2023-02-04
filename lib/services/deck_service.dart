import 'package:dominion_comanion/database/card_database.dart';
import 'package:dominion_comanion/database/deck_database.dart';
import 'package:dominion_comanion/database/model/deck/deck_db_model.dart';
import 'package:dominion_comanion/model/card/card_model.dart';
import 'package:dominion_comanion/model/deck/deck_model.dart';
import 'package:dominion_comanion/services/card_service.dart';

class DeckService {
  late DeckDatabase _deckDatabase;
  late CardDatabase _cardDatabase;
  final int deckSize = 10;

  DeckService() {
    _deckDatabase = DeckDatabase();
    _cardDatabase = CardDatabase();
  }

  Future<List<DeckDBModel>> getDeckList() {
    return _deckDatabase.getDeckList();
  }

  Future<int> addDeck(deck) {
    return _deckDatabase.insertDeck(deck);
  }

  Future<int> deleteDeckByName(String name) {
    return _deckDatabase.deleteDeckByName(name);
  }

  Future<DeckModel> createTemporaryDeck(String name,
      List<String> cardIds) async {
    cardIds.shuffle();
    return DeckModel(
        name,
        await Future.wait(cardIds.take(deckSize).toList().map((cardId) async =>
            CardModel.fromDBModel(await _cardDatabase.getCardById(cardId)))
            .toList()));
  }
}
