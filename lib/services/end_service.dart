import 'dart:async';
import 'dart:developer';

import 'package:dominion_comanion/database/end_database.dart';
import 'package:dominion_comanion/database/model/expansion/expansion_db_model.dart';
import 'package:dominion_comanion/database/model/end/end_db_model.dart';

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

  Future<List<EndDBModel>> getAlwaysEnds() async {
    return await _endDatabase.getAlwaysEndList();
  }

  Future<EndDBModel> getEndByExpansionFromDB(
      ExpansionDBModel expansion) async {
    return await _endDatabase.getEndById(expansion.endId);
  }
}
