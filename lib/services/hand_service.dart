import 'dart:async';
import 'dart:developer';

import 'package:dominion_companion/database/hand_database.dart';
import 'package:dominion_companion/database/model/hand/hand_db_model.dart';
import 'package:dominion_companion/model/hand/hand_type_enum.dart';

class HandService {
  late HandDatabase _handDatabase;

  HandService() {
    _handDatabase = HandDatabase();
  }

  Future<int> deleteHandTable() {
    return _handDatabase.deleteHandTable();
  }

  void insertHandIntoDB(HandDBModel handDBModel) {
    _handDatabase.insertHand(handDBModel);
  }

  Future<List<HandDBModel>> getAlwaysHandsByType(HandTypeEnum type) async {
    return await _handDatabase.getAlwaysHandListByType(type);
  }

  Future<List<HandDBModel>> getHandsByExpansionIdAndType(
      String expansionId, HandTypeEnum type) async {
    return await _handDatabase.getHandsByExpansionIdAndType(expansionId, type);
  }
}
