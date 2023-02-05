import 'package:dominion_comanion/database/selectedCardsDatabase.dart';
import 'package:dominion_comanion/model/deck/deck_model.dart';

class TemporaryDeckService {
  late Future<DeckModel> temporaryDeck;
  bool saved = false;

  static final TemporaryDeckService _temporaryDeckService =
      TemporaryDeckService._internal();

  factory TemporaryDeckService() {
    return _temporaryDeckService;
  }

  TemporaryDeckService._internal();
}
