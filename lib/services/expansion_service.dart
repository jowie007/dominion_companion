import 'dart:developer';

import 'package:dominion_comanion/database/expansion_database.dart';
import 'package:dominion_comanion/database/model/card/card_db_model.dart';
import 'package:dominion_comanion/database/model/content/content_db_model.dart';
import 'package:dominion_comanion/database/model/expansion/expansion_db_model.dart';
import 'package:dominion_comanion/model/card/card_model.dart';
import 'package:dominion_comanion/model/content/content_model.dart';
import 'package:dominion_comanion/model/expansion/expansion_model.dart';
import 'package:dominion_comanion/services/card_service.dart';
import 'package:dominion_comanion/services/content_service.dart';
import 'package:dominion_comanion/services/json_service.dart';

class ExpansionService {
  late ExpansionDatabase _expansionDatabase;
  late CardService _cardService;
  late ContentService _contentService;

  ExpansionService() {
    _expansionDatabase = ExpansionDatabase();
    _cardService = CardService();
    _contentService = ContentService();
  }

  Future<int> deleteExpansionTable() {
    return _expansionDatabase.deleteExpansionTable();
  }

  void insertExpansionIntoDB(ExpansionModel expansionModel) {
    _expansionDatabase
        .insertExpansion(ExpansionDBModel.fromModel(expansionModel));
    for (var element in expansionModel.cards) {
      _cardService.insertCardIntoDB(CardDBModel.fromModel(element));
    }
    for (var element in expansionModel.content) {
      _contentService.insertContentIntoDB(ContentDBModel.fromModel(element));
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
    return Future.wait((await getExpansionFromDB()).map((expansion) async =>
        ExpansionModel.fromDBModelAndCardsAndContent(
            expansion,
            (await _cardService.getCardsByExpansionFromDB(expansion))
                .map((card) => CardModel.fromDBModel(card))
                .toList(),
            (await _contentService.getContentByExpansionFromDB(expansion))
                .map((content) => ContentModel.fromDBModel(content))
                .toList())));
  }

  Future<List<ExpansionDBModel>> getExpansionFromDB() {
    return _expansionDatabase.getExpansionList();
  }
}
