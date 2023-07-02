import 'dart:async';
import 'dart:developer';

import 'package:dominion_companion/database/end_database.dart';
import 'package:dominion_companion/database/model/expansion/expansion_db_model.dart';
import 'package:dominion_companion/database/model/end/end_db_model.dart';
import 'package:dominion_companion/model/end/end_model.dart';

class EndService {
  late EndDatabase _endDatabase;

  EndService() {
    _endDatabase = EndDatabase();
  }

  Future<int> deleteEndTable() {
    return _endDatabase.deleteEndTable();
  }

  void insertEndIntoDB(EndDBModel endDBModel) {
    _endDatabase.insertEnd(endDBModel);
  }

  Future<void> insertEndModelsIntoDB(List<EndModel> endModels) {
    return _endDatabase.insertEnds(endModels
        .map((endModel) => EndDBModel.fromModel(endModel))
        .toList());
  }

  Future<List<EndDBModel>> getAlwaysEnds() async {
    return await _endDatabase.getAlwaysEndList();
  }

  Future<EndDBModel> getEndByEndIdFromDB(
      String endId) async {
    return await _endDatabase.getEndByEndId(endId);
  }

  Future<EndDBModel?> getEndByExpansionIdFromDB(
      String expansionId) async {
    return await _endDatabase.getEndByExpansionId(expansionId);
  }
}
