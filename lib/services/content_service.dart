import 'dart:async';
import 'dart:developer';

import 'package:dominion_companion/database/content_database.dart';
import 'package:dominion_companion/database/model/content/content_db_model.dart';
import 'package:dominion_companion/database/model/expansion/expansion_db_model.dart';

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

  Future<ContentDBModel> getContentById(String contentId) async {
    return await _contentDatabase.getContentById(contentId);
  }

  Future<List<ContentDBModel>> getAlwaysContents() async {
    return await _contentDatabase.getAlwaysContentList();
  }

  Future<List<ContentDBModel>>
      getWhenDeckConsistsOfXContentTypesOfExpansionContents() async {
    return await _contentDatabase.getWhenDeckConsistsOfXCards();
  }

  Future<List<ContentDBModel>> getContentByExpansionId(
      String expansionId) async {
    return await _contentDatabase.getContentByExpansionId(expansionId);
  }

  Future<List<ContentDBModel>> getContentByExpansionFromDB(
      ExpansionDBModel expansion) async {
    return getContentByExpansionId(expansion.id);
  }
}
