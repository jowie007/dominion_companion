import 'dart:developer';

import 'package:dominion_comanion/database/expansion_database.dart';
import 'package:dominion_comanion/database/model/card/card_db_model.dart';
import 'package:dominion_comanion/database/model/content/content_db_model.dart';
import 'package:dominion_comanion/database/model/end/end_db_model.dart';
import 'package:dominion_comanion/database/model/expansion/expansion_db_model.dart';
import 'package:dominion_comanion/database/model/hand/hand_db_model.dart';
import 'package:dominion_comanion/model/card/card_model.dart';
import 'package:dominion_comanion/model/content/content_model.dart';
import 'package:dominion_comanion/model/end/end_model.dart';
import 'package:dominion_comanion/model/expansion/expansion_model.dart';
import 'package:dominion_comanion/model/hand/hand_model.dart';
import 'package:dominion_comanion/model/hand/hand_type_enum.dart';
import 'package:dominion_comanion/services/card_service.dart';
import 'package:dominion_comanion/services/content_service.dart';
import 'package:dominion_comanion/services/end_service.dart';
import 'package:dominion_comanion/services/hand_service.dart';
import 'package:dominion_comanion/services/json_service.dart';

class ExpansionService {
  late ExpansionDatabase _expansionDatabase;
  late CardService _cardService;
  late ContentService _contentService;
  late HandService _handService;
  late EndService _endService;

  ExpansionService() {
    _expansionDatabase = ExpansionDatabase();
    _cardService = CardService();
    _contentService = ContentService();
    _handService = HandService();
    _endService = EndService();
  }

  Future<int> deleteExpansionTable() {
    return _expansionDatabase.deleteExpansionTable();
  }

  String getExpansionName(ExpansionModel expansion) {
    return expansion.version == "V1"
        ? expansion.name
        : [expansion.name, expansion.version].join(" - ");
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
    for (var element in [
      ...expansionModel.handMoneyCards,
      ...expansionModel.handOtherCards,
      ...expansionModel.handContents
    ]) {
      _handService.insertHandIntoDB(HandDBModel.fromModel(element));
    }
    if (expansionModel.end != null) {
      _endService.insertEndIntoDB(EndDBModel.fromModel(expansionModel.end!));
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

  Future<List<CardModel>> getSortedCardsByExpansionDBModel(ExpansionDBModel expansionDBModel) async {
    var cards = (await _cardService.getCardsByExpansionFromDB(expansionDBModel))
        .map((card) => CardModel.fromDBModel(card))
        .toList();
    cards.sort((a, b) => CardModel.sortCardComparisonExpansion(a, b));
    return cards;
  }

  Future<List<ExpansionModel>> loadAllExpansions() async {
    log("ALL FINE 1");
    return Future.wait((await getExpansionsFromDB()).map(
      (expansion) async => ExpansionModel.fromDBModelAndAdditional(
          expansion,
          await getSortedCardsByExpansionDBModel(expansion),
          (await _contentService.getContentByExpansionId(expansion.id))
              .map((content) => ContentModel.fromDBModel(content))
              .toList(),
          (await _handService.getHandsByExpansionIdAndType(
                  expansion.id, HandTypeEnum.moneyCards))
              .map((hand) => HandModel.fromDBModel(hand))
              .toList(),
          (await _handService.getHandsByExpansionIdAndType(
                  expansion.id, HandTypeEnum.otherCards))
              .map((hand) => HandModel.fromDBModel(hand))
              .toList(),
          (await _handService.getHandsByExpansionIdAndType(
                  expansion.id, HandTypeEnum.contents))
              .map((hand) => HandModel.fromDBModel(hand))
              .toList(),
          expansion.endId != null
              ? (EndModel.fromDBModel(
                  await _endService.getEndByEndIdFromDB(expansion.endId!)))
              : null),
    ));
  }

  Future<List<ExpansionDBModel>> getExpansionsFromDB() {
    return _expansionDatabase.getExpansionList();
  }
}
