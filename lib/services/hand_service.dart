import 'dart:async';

import 'package:dominion_comanion/database/hand_database.dart';
import 'package:dominion_comanion/database/model/expansion/expansion_db_model.dart';
import 'package:dominion_comanion/database/model/hand/hand_db_model.dart';

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

  Future<List<HandDBModel>> getAlwaysHands() async {
    return await _handDatabase.getAlwaysHandList();
  }

  Future<HandDBModel> getHandByExpansionFromDB(
      ExpansionDBModel expansion) async {
    return await _handDatabase.getHandById(expansion.handId);
  }
}