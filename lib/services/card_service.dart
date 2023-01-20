import 'package:dominion_comanion/database/card_database.dart';
import 'package:dominion_comanion/database/model/card/card_db_model.dart';
import 'package:dominion_comanion/database/model/expansion/expansion_db_model.dart';

class CardService {
  late CardDatabase _cardDatabase;

  CardService() {
    _cardDatabase = CardDatabase();
  }

  void insertCardIntoDB(CardDBModel cardDBModel) {
    _cardDatabase.insertCard(cardDBModel);
  }

  Future<List<CardDBModel>> getCardsByExpansionFromDB(ExpansionDBModel expansion) async {
    var cards = expansion.cardIds
        .map((cardId) async => await _cardDatabase.getCardById(cardId))
        .toList();
    return await Future.wait(cards);
  }
}
