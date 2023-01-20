import 'package:dominion_comanion/database/deck_database.dart';
import 'package:dominion_comanion/database/model/deck/deck_db_model.dart';

class DeckService {
  late List<DeckDBModel> decks;
  final DeckDatabase deckDatabase = DeckDatabase();

  Future<List<DeckDBModel>> getDeckList() {
    return deckDatabase.getDeckList();
  }

  Future<int> addDeck(deck) {
    return deckDatabase.insertDeck(deck);
  }

  Future<int> deleteDeckById(String id) {
    return deckDatabase.deleteDeckById(id);
  }
}
