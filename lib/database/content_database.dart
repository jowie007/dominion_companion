import 'dart:async';

import 'package:dominion_companion/database/model/content/content_db_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// https://docs.flutter.dev/cookbook/persistence/sqlite
// https://medium.com/flutterdevs/sql-database-storage-using-sqlite-in-flutter-6e2fdcc8cfb7
class ContentDatabase {
  late Database _database;

  Future openDb() async {
    _database = await openDatabase(join(await getDatabasesPath(), "content.db"),
        version: 1, onCreate: (Database db, int version) async {
      await db.execute(
        "CREATE TABLE content("
        "id STRING PRIMARY KEY, "
        "name STRING, "
        "always TRUE, "
        "whenDeckConsistsOfXCards STRING, "
        "count STRING)",
      );
    });
    return _database;
  }

  Future<int> deleteContentTable() async {
    await openDb();
    return await _database.delete('content');
  }

  Future<int> insertContent(ContentDBModel content) async {
    await openDb();
    return await _database.insert('content', content.toJson());
  }

  Future<void> insertContents(List<ContentDBModel> contents) async {
    await openDb();
    var batch = _database.batch();
    for (var content in contents) {
      batch.insert('content', content.toJson());
    }
    await batch.commit(noResult: true);
  }

  Future<List<ContentDBModel>> getContentList() async {
    await openDb();
    final List<Map<String, dynamic>> maps = await _database.query('content');
    return List.generate(maps.length, (i) {
      return ContentDBModel.fromDB(maps[i]);
    });
  }

  Future<List<ContentDBModel>> getAlwaysContentList() async {
    await openDb();
    final List<Map<String, dynamic>> maps =
        await _database.rawQuery('SELECT * FROM content WHERE always=?', [1]);
    return List.generate(maps.length, (i) {
      return ContentDBModel.fromDB(maps[i]);
    });
  }

  Future<List<ContentDBModel>> getWhenDeckConsistsOfXCards() async {
    await openDb();
    final List<Map<String, dynamic>> maps = await _database.rawQuery(
        'SELECT * FROM content WHERE length(whenDeckConsistsOfXCards) > 0');
    return List.generate(maps.length, (i) {
      return ContentDBModel.fromDB(maps[i]);
    });
  }

  Future<ContentDBModel> getContentById(String id) async {
    await openDb();
    final List<Map<String, dynamic>> maps = await _database
        .rawQuery('SELECT * FROM content WHERE id LIKE ?', ["$id%"]);
    return ContentDBModel.fromDB(maps.first);
  }

  Future<List<ContentDBModel>> getContentByExpansionId(
      String expansionId) async {
    await openDb();
    final List<Map<String, dynamic>> maps = await _database
        .rawQuery('SELECT * FROM content WHERE id LIKE ?', ["$expansionId%"]);
    return List.generate(maps.length, (i) {
      return ContentDBModel.fromDB(maps[i]);
    });
  }

  Future<int> updateContent(ContentDBModel content) async {
    await openDb();
    return await _database.update('content', content.toJson(),
        where: "id = ?", whereArgs: [content.id]);
  }

  Future<int> deleteContentById(String id) async {
    await openDb();
    return await _database.delete('content', where: "id = ?", whereArgs: [id]);
  }
}
