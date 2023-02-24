import 'package:dominion_comanion/database/card_database.dart';
import 'package:dominion_comanion/database/deck_database.dart';
import 'package:dominion_comanion/database/model/deck/deck_db_model.dart';
import 'package:dominion_comanion/model/card/card_model.dart';
import 'package:dominion_comanion/model/deck/deck_model.dart';
import 'package:flutter/cupertino.dart';

class DeckService {
  final DeckDatabase _deckDatabase = DeckDatabase();
  final CardDatabase _cardDatabase = CardDatabase();
  late ValueNotifier<bool> changeNotify;

  static final DeckService _deckService = DeckService._internal();

  static int deckSize = 10;

  factory DeckService() {
    return _deckService;
  }

  DeckService._internal();

  void initializeChangeNotify() {
    changeNotify = ValueNotifier(false);
  }

  Future<List<DeckDBModel>> getDeckList() {
    return _deckDatabase.getDeckList();
  }

  Future<int> saveDeck(DeckModel deckModel) {
    changeNotify.value = !changeNotify.value;
    return _deckDatabase.insertDeck(DeckDBModel.fromModel(deckModel));
  }

  Future<int> deleteDeckByName(String name) {
    changeNotify.value = !changeNotify.value;
    return _deckDatabase.deleteDeckByName(name);
  }

  Future<DeckModel> deckFromNameAndCardIds(
      String name, List<String> cardIds) async {
    cardIds.shuffle();
    return DeckModel(
        name,
        await Future.wait(cardIds
            .toList()
            .map((cardId) async =>
                CardModel.fromDBModel(await _cardDatabase.getCardById(cardId)))
            .toList()));
  }
}
