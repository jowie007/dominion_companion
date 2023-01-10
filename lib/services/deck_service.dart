import 'package:dominion_comanion/database/deck_database.dart';
import 'package:dominion_comanion/model/deck/deck_model.dart';

class DeckService {
  late List<Deck> decks;
  final DeckDatabase deckDatabase = DeckDatabase();

  Future<List<Deck>> getDeckList() {
    return deckDatabase.getDeckList();
  }

  Future<int> addDeck(deck) {
    return deckDatabase.insertDeck(deck);
  }

  Future<int> deleteDeckById(int id) {
    return deckDatabase.deleteDeckById(id);
  }
}
