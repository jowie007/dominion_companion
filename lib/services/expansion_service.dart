import 'dart:developer';

import 'package:dominion_companion/database/expansion_database.dart';
import 'package:dominion_companion/database/model/card/card_db_model.dart';
import 'package:dominion_companion/database/model/content/content_db_model.dart';
import 'package:dominion_companion/database/model/end/end_db_model.dart';
import 'package:dominion_companion/database/model/expansion/expansion_db_model.dart';
import 'package:dominion_companion/database/model/hand/hand_db_model.dart';
import 'package:dominion_companion/model/card/card_model.dart';
import 'package:dominion_companion/model/content/content_model.dart';
import 'package:dominion_companion/model/end/end_model.dart';
import 'package:dominion_companion/model/expansion/expansion_model.dart';
import 'package:dominion_companion/model/hand/hand_model.dart';
import 'package:dominion_companion/model/hand/hand_type_enum.dart';
import 'package:dominion_companion/services/card_service.dart';
import 'package:dominion_companion/services/content_service.dart';
import 'package:dominion_companion/services/end_service.dart';
import 'package:dominion_companion/services/hand_service.dart';
import 'package:dominion_companion/services/json_service.dart';

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

  /*void insertExpansionModelsIntoDB(List<ExpansionModel> expansionModels) {
    _expansionDatabase
        .insertExpansion(ExpansionDBModel.fromModel(expansionModel));
    _cardService.insertCardModelsIntoDB(expansionModel.cards);
    _contentService.insertContentModelsIntoDB(expansionModel.content);
    _handService.insertHandModelsIntoDB([
      ...expansionModel.handMoneyCards,
      ...expansionModel.handOtherCards,
      ...expansionModel.handContents
    ]);
    if (expansionModel.end != null) {
      _endService.insertEndIntoDB(EndDBModel.fromModel(expansionModel.end!));
    }
  }*/

  Future<void> insertExpansionModelsIntoDB(List<ExpansionModel> expansionModels) {
    return _expansionDatabase.insertExpansions(expansionModels
        .map((expansionModel) => ExpansionDBModel.fromModel(expansionModel))
        .toList());
  }

  void insertExpansionsWithDependenciesIntoDB(List<ExpansionModel> expansionModels) async {
    await insertExpansionModelsIntoDB(expansionModels);
    /*_expansionDatabase
        .insertExpansionModelsIntoDB(ExpansionDBModel.fromModel(expansionModels));*/
    var cards = expansionModels.expand((e) => e.cards).toList();
    await _cardService.insertCardModelsIntoDB(cards);
    var contents = expansionModels.expand((e) => e.content).toList();
    await _contentService.insertContentModelsIntoDB(contents);
    var hands = expansionModels.expand((e) => [
      ...e.handMoneyCards,
      ...e.handOtherCards,
      ...e.handContents
    ]).toList();
    await _handService.insertHandModelsIntoDB(hands);
    List<EndModel> ends = [];
    for (var expansionModel in expansionModels) {
      if(expansionModel.end != null) {
        ends.add(expansionModel.end!);
      }
    }
    await _endService.insertEndModelsIntoDB(ends);
  }

  Future<void> loadJsonExpansionsIntoDB() async {
    insertExpansionsWithDependenciesIntoDB(await Future.wait(JsonService().getExpansionsFromJSON()));
    /*JsonService().getExpansionsFromJSON().forEach((expansionModel) async {
      insertExpansionIntoDB(await expansionModel);
    });*/
  }

  Future<List<CardModel>> getSortedCardsByExpansionDBModel(
      ExpansionDBModel expansionDBModel) async {
    var cards = (await _cardService.getCardsByExpansionFromDB(expansionDBModel))
        .map((card) => CardModel.fromDBModel(card))
        .toList();
    cards.sort((a, b) => CardModel.sortCardComparisonExpansion(a, b));
    return cards;
  }

  Future<ExpansionModel> expansionModelFromExpansionDB(
      ExpansionDBModel expansionDBModel) async {
    return ExpansionModel.fromDBModelAndAdditional(
        expansionDBModel,
        await getSortedCardsByExpansionDBModel(expansionDBModel),
        (await _contentService.getContentByExpansionId(expansionDBModel.id))
            .map((content) => ContentModel.fromDBModel(content))
            .toList(),
        (await _handService.getHandsByExpansionIdAndType(
                expansionDBModel.id, HandTypeEnum.moneyCards))
            .map((hand) => HandModel.fromDBModel(hand))
            .toList(),
        (await _handService.getHandsByExpansionIdAndType(
                expansionDBModel.id, HandTypeEnum.otherCards))
            .map((hand) => HandModel.fromDBModel(hand))
            .toList(),
        (await _handService.getHandsByExpansionIdAndType(
                expansionDBModel.id, HandTypeEnum.contents))
            .map((hand) => HandModel.fromDBModel(hand))
            .toList(),
        expansionDBModel.endId != null
            ? (EndModel.fromDBModel(
                await _endService.getEndByEndIdFromDB(expansionDBModel.endId!)))
            : null);
  }

  Future<List<ExpansionModel>> loadAllExpansions() async {
    return Future.wait((await getExpansionsFromDB()).map(
        (expansionDBModel) async =>
            expansionModelFromExpansionDB(expansionDBModel)));
  }

  Future<List<ExpansionDBModel>> getExpansionsFromDB() {
    return _expansionDatabase.getExpansionList();
  }

  Future<ExpansionModel?> getExpansionByPosition(int position) async {
    ExpansionDBModel? expansion =
        await _expansionDatabase.getExpansionByPosition(position);
    return expansion != null ? expansionModelFromExpansionDB(expansion) : null;
  }
}
