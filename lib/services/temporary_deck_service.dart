import 'dart:developer';

import 'package:dominion_comanion/database/card_database.dart';
import 'package:dominion_comanion/database/model/deck/deck_db_model.dart';
import 'package:dominion_comanion/model/card/card_model.dart';
import 'package:dominion_comanion/model/content/content_model.dart';
import 'package:dominion_comanion/model/deck/deck_model.dart';
import 'package:dominion_comanion/model/end/end_model.dart';
import 'package:dominion_comanion/model/hand/hand_model.dart';
import 'package:dominion_comanion/services/card_service.dart';
import 'package:dominion_comanion/services/content_service.dart';
import 'package:dominion_comanion/services/deck_service.dart';
import 'package:dominion_comanion/services/end_service.dart';
import 'package:dominion_comanion/services/hand_service.dart';

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

  Future<void> createTemporaryDBDeck(String name, List<String> cardIds) async {
    cardIds.shuffle();
    temporaryDeck = createTemporaryDeck(name, cardIds);
  }

  Future<DeckModel> createTemporaryDeck(String name,
      List<String> cardIds) async {
    cardIds.shuffle();
    return _deckService.deckFromDBModel(
        DeckDBModel(name, cardIds.take(DeckService.deckSize).toList()));
  }
}
