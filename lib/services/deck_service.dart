import 'package:dominion_comanion/database/deck_database.dart';
import 'package:dominion_comanion/database/model/deck/deck_db_model.dart';

class DeckService {
  late List<DeckDBModel> decks;
  final DeckDatabase deckDatabase = DeckDatabase();

  Future<List<DeckDBModel>> getDeckList() {
    // deckDatabase.insertDeck(const Deck(id: "2", name: "Test deck", cardIds: ["1", "2", "3"]));
    return deckDatabase.getDeckList();
  }

  Future<int> addDeck(deck) {
    return deckDatabase.insertDeck(deck);
  }

  Future<int> deleteDeckById(int id) {
    return deckDatabase.deleteDeckById(id);
  }
}
