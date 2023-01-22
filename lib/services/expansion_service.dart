import 'package:dominion_comanion/database/expansion_database.dart';
import 'package:dominion_comanion/database/model/card/card_db_model.dart';
import 'package:dominion_comanion/database/model/expansion/expansion_db_model.dart';
import 'package:dominion_comanion/model/card/card_model.dart';
import 'package:dominion_comanion/model/expansion/expansion_model.dart';
import 'package:dominion_comanion/services/card_service.dart';
import 'package:dominion_comanion/services/json_service.dart';

class ExpansionService {
  late ExpansionDatabase _expansionDatabase;
  late CardService _cardService;

  ExpansionService() {
    _expansionDatabase = ExpansionDatabase();
    _cardService = CardService();
  }

  void insertExpansionIntoDB(ExpansionModel expansionModel) {
    _expansionDatabase
        .insertExpansion(ExpansionDBModel.fromModel(expansionModel));
    for (var element in expansionModel.cards) {
      _cardService.insertCardIntoDB(CardDBModel.fromModel(element));
    }
  }

  Future<void> loadJsonExpansionsIntoDB() async {
    /* await Future.wait(JsonService().getExpansions().map((element) async => {
      _expansionDatabase.deleteExpansionById((await element).id)
    }).toList()); */
    JsonService().getExpansions().forEach((expansionModel) async {
      insertExpansionIntoDB(await expansionModel);
    });
  }

  Future<List<ExpansionModel>> loadAllExpansions() async {
    return await Future.wait((await getExpansionFromDB()).map(
        (expansion) async => ExpansionModel.fromDBModelAndCards(
            expansion,
            (await _cardService.getCardsByExpansionFromDB(expansion))
                .map((card) => CardModel.fromDBModel(card))
                .toList())));
  }

  Future<List<ExpansionDBModel>> getExpansionFromDB() {
    return _expansionDatabase.getExpansionList();
  }
}
