import 'package:dominion_comanion/model/deck/deck_model.dart';
import 'package:dominion_comanion/services/card_service.dart';
import 'package:dominion_comanion/services/deck_service.dart';

class TemporaryDeckService {
  final DeckService _deckService = DeckService();
  final CardService _cardService = CardService();
  late Future<DeckModel> temporaryDeck;
  bool saved = false;


  static final TemporaryDeckService _temporaryDeckService =
      TemporaryDeckService._internal();

  factory TemporaryDeckService() {
    return _temporaryDeckService;
  }

  TemporaryDeckService._internal();

  Future<void> createTemporaryDeck(String name, List<String> cardIds) async {
    List<String> alwaysCardIds = await Future.wait((await _cardService.getAlwaysCards()).map(
            (card) async => card.id));
    temporaryDeck = _deckService.deckFromNameAndCardIds(name, cardIds.take(DeckService.deckSize).toList()..addAll(alwaysCardIds));
  }
}
