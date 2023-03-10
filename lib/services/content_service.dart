import 'dart:async';
import 'dart:developer';

import 'package:dominion_comanion/database/content_database.dart';
import 'package:dominion_comanion/database/model/content/content_db_model.dart';
import 'package:dominion_comanion/database/model/expansion/expansion_db_model.dart';

class ContentService {
  late ContentDatabase _contentDatabase;

  ContentService() {
    _contentDatabase = ContentDatabase();
  }

  Future<int> deleteContentTable() {
    return _contentDatabase.deleteContentTable();
  }

  void insertContentIntoDB(ContentDBModel contentDBModel) {
    _contentDatabase.insertContent(contentDBModel);
  }

  Future<List<ContentDBModel>> getAlwaysContents() async {
    return await _contentDatabase.getAlwaysContentList();
  }

  Future<List<ContentDBModel>>
      getWhenDeckConsistsOfXContentTypesOfExpansionContents() async {
    return await _contentDatabase.getWhenDeckConsistsOfXCards();
  }

  Future<List<ContentDBModel>> getContentByExpansionFromId(
      String contentId) async {
    return await _contentDatabase.getContentById(contentId);
  }

  Future<List<ContentDBModel>> getContentByExpansionFromDB(
      ExpansionDBModel expansion) async {
    return getContentByExpansionFromId(expansion.id);
  }
}
