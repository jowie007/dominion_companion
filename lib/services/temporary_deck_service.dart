import 'package:dominion_comanion/model/deck/deck_model.dart';
import 'package:dominion_comanion/services/deck_service.dart';

class TemporaryDeckService {
  final DeckService _deckService = DeckService();
  late Future<DeckModel> temporaryDeck;
  bool saved = false;

  static final TemporaryDeckService _temporaryDeckService =
      TemporaryDeckService._internal();

  factory TemporaryDeckService() {
    return _temporaryDeckService;
  }

  TemporaryDeckService._internal();

  void createTemporaryDeck(String name, List<String> cardIds) {
    temporaryDeck = _deckService.deckFromNameAndCardIds(name, cardIds);
  }
}
