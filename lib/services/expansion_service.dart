import 'dart:developer';

import 'package:dominion_companion/database/expansion_database.dart';
import 'package:dominion_companion/database/model/expansion/expansion_db_model.dart';
import 'package:dominion_companion/model/card/card_model.dart';
import 'package:dominion_companion/model/content/content_model.dart';
import 'package:dominion_companion/model/end/end_model.dart';
import 'package:dominion_companion/model/expansion/expansion_model.dart';
import 'package:dominion_companion/model/hand/hand_model.dart';
import 'package:dominion_companion/model/hand/hand_type_enum.dart';
import 'package:dominion_companion/services/active_expansion_version_service.dart';
import 'package:dominion_companion/services/card_service.dart';
import 'package:dominion_companion/services/content_service.dart';
import 'package:dominion_companion/services/end_service.dart';
import 'package:dominion_companion/services/hand_service.dart';
import 'package:dominion_companion/services/json_service.dart';
import 'package:sqflite/sqflite.dart';

class ExpansionService {
  late ExpansionDatabase _expansionDatabase;
  late CardService _cardService;
  late ContentService _contentService;
  late ActiveExpansionVersionService _activeExpansionVersionService;
  late HandService _handService;
  late EndService _endService;

  ExpansionService() {
    _expansionDatabase = ExpansionDatabase();
    _cardService = CardService();
    _contentService = ContentService();
    _activeExpansionVersionService = ActiveExpansionVersionService();
    _handService = HandService();
    _endService = EndService();
  }

  Future<void> deleteDb() async {
    _expansionDatabase.deleteDb();
  }

  String getExpansionName(ExpansionModel expansion) {
    return expansion.version == "V1"
        ? expansion.name
        : [expansion.name, expansion.version].join(" - ");
  }

  Future<void> insertExpansionModelsIntoDB(
      List<ExpansionModel> expansionModels) {
    return _expansionDatabase.insertExpansions(expansionModels
        .map((expansionModel) => ExpansionDBModel.fromModel(expansionModel))
        .toList());
  }

  Future<void> insertExpansionsWithDependenciesIntoDB(
      List<ExpansionModel> expansionModels) async {
    await insertExpansionModelsIntoDB(expansionModels);
    var cards = expansionModels.expand((e) => e.cards).toList();
    await _cardService.insertCardModelsIntoDB(cards);
    var contents = expansionModels.expand((e) => e.content).toList();
    await _contentService.insertContentModelsIntoDB(contents);
    var hands = expansionModels
        .expand((e) =>
            [...e.handMoneyCards, ...e.handOtherCards, ...e.handContents])
        .toList();
    await _handService.insertHandModelsIntoDB(hands);
    List<EndModel> ends = [];
    for (var expansionModel in expansionModels) {
      if (expansionModel.end != null) {
        ends.add(expansionModel.end!);
      }
    }
    await _endService.insertEndModelsIntoDB(ends);
  }

  Future<void> loadJsonExpansionsIntoDB() async {
    await insertExpansionsWithDependenciesIntoDB(
        await JsonService().getExpansionsFromJSON());
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

  Future<ExpansionModel?> getActiveExpansionByPosition(int position) async {
    List<String> activeExpansionIds =
        await _activeExpansionVersionService.getSelectedExpansionIds();
    ExpansionDBModel? expansion = await _expansionDatabase
        .getActiveExpansionByPosition(position, activeExpansionIds);
    return expansion != null ? expansionModelFromExpansionDB(expansion) : null;
  }

  Future<List<ExpansionModel>> getAllExpansionsStartingWithId(
      String expansionId) async {
    String expansionPrefix = expansionId.split("_")[0];
    return Future.wait((await _expansionDatabase
            .getAllExpansionsStartingWithId(expansionPrefix))
        .map((expansionDBModel) async =>
            expansionModelFromExpansionDB(expansionDBModel)));
  }

  Future<List<String>> getAllExpansionIdsStartingWithId(
      String expansionId) async {
    return (await getAllExpansionsStartingWithId(expansionId))
        .map((expansion) => expansion.id)
        .toList();
  }

  Future<List<String>> getAllExpansionNamesStartingWithId(
      String expansionId) async {
    return (await getAllExpansionsStartingWithId(expansionId))
        .map((expansion) => getExpansionName(expansion))
        .toList();
  }

  Future<Map<String, String>> getAllExpansionNamesAndIdsStartingWithId(
      String expansionId) async {
    List<ExpansionModel> allExpansions =
        await getAllExpansionsStartingWithId(expansionId);
    return Map.fromEntries(allExpansions.map(
        (expansion) => MapEntry(expansion.id, getExpansionName(expansion))));
  }

  Future<List<String>> getUniqueExpansionIdsWithHigherPriority() async {
    List<ExpansionDBModel> expansions = await getExpansionsFromDB();
    List<ExpansionDBModel> uniqueExpansions = [];
    for (var expansion in expansions) {
      bool alreadyExists = false;
      for (var uniqueExpansion in uniqueExpansions) {
        if (uniqueExpansion.id.startsWith(expansion.id.split("_")[0])) {
          alreadyExists = true;
          if (expansion.priority > uniqueExpansion.priority) {
            uniqueExpansions.remove(uniqueExpansion);
            uniqueExpansions.add(expansion);
          }
          break;
        }
      }
      if (!alreadyExists) {
        uniqueExpansions.add(expansion);
      }
    }
    return uniqueExpansions.map((expansion) => expansion.id).toList();
  }

  Future<List<String>> getExpansionIdsWithSamePrefix(String expansionId) async {
    List<ExpansionDBModel> expansions = await getExpansionsFromDB();
    return expansions
        .where(
            (expansion) => expansion.id.startsWith(expansionId.split("_")[0]))
        .map((expansion) => expansion.id)
        .toList();
  }

  Future<List<ExpansionModel>> getExpansionsWithSamePrefix(
      String expansionId) async {
    List<ExpansionDBModel> expansions = await getExpansionsFromDB();
    return Future.wait(expansions
        .where(
            (expansion) => expansion.id.startsWith(expansionId.split("_")[0]))
        .map((expansion) => expansionModelFromExpansionDB(expansion))
        .toList());
  }

  Future<List<ExpansionModel>> getExpansionsWithSamePrefixExcludeItself(
      String expansionId) async {
    List<ExpansionModel> expansions =
        await getExpansionsWithSamePrefix(expansionId);
    return expansions
        .where((expansion) => expansion.id != expansionId)
        .toList();
  }
}
