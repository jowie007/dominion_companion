import 'dart:async';

import 'package:dominion_companion/database/model/expansion/expansion_db_model.dart';
import 'package:dominion_companion/model/expansion/expansion_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// https://docs.flutter.dev/cookbook/persistence/sqlite
// https://medium.com/flutterdevs/sql-database-storage-using-sqlite-in-flutter-6e2fdcc8cfb7
class ExpansionDatabase {
  late Database _database;

  Future openDb() async {
    _database = await openDatabase(
        join(await getDatabasesPath(), "expansion.db"),
        version: 1, onCreate: (Database db, int version) async {
      await db.execute(
        "CREATE TABLE expansion(id STRING PRIMARY KEY, "
        "name STRING, "
        "version STRING, "
        "priority INTEGER, "
        "cardIds STRING, "
        "contentIds STRING, "
        "handMoneyCardIds STRING, "
        "handOtherCardIds STRING, "
        "handContentIds STRING, "
        "endId STRING)",
      );
    });
    return _database;
  }

  Future<ExpansionDBModel?> getActiveExpansionByPosition(
      int position, List<String> activeExpansionIds) async {
    await openDb();
    String formattedIds = activeExpansionIds.map((id) => "'$id'").join(', ');
    final List<Map<String, dynamic>> maps = await _database.rawQuery(
        'SELECT * FROM expansion WHERE id IN ($formattedIds) LIMIT 1 OFFSET $position');
    return maps.isNotEmpty ? ExpansionDBModel.fromDB(maps.first) : null;
  }

  Future<List<ExpansionDBModel>> getAllExpansionsStartingWithId(
      String id) async {
    await openDb();
    final List<Map<String, dynamic>> maps = await _database.rawQuery(
        'SELECT * FROM expansion WHERE id LIKE ? ORDER BY name;', ["$id%"]);
    return maps.isNotEmpty
        ? List.generate(maps.length, (i) {
            return ExpansionDBModel.fromDB(maps[i]);
          })
        : [];
  }

  Future<List<String>> getAllExpansionNamesStartingWithId(String id) async {
    await openDb();
    final List<Map<String, dynamic>> maps = await _database.rawQuery(
        'SELECT name FROM expansion WHERE id LIKE ? ORDER BY name;', ["$id%"]);
    return maps.isNotEmpty
        ? List.generate(maps.length, (i) {
            return maps[i]['name'];
          })
        : [];
  }

  Future<void> deleteDb() async {
    String path = join(await getDatabasesPath(), "expansion.db");
    await deleteDatabase(path);
  }

  Future<int> insertExpansion(ExpansionDBModel expansion) async {
    await openDb();
    return await _database.insert('expansion', expansion.toJson());
  }

  Future<void> insertExpansions(List<ExpansionDBModel> expansions) async {
    await openDb();
    var batch = _database.batch();
    for (var expansion in expansions) {
      batch.insert('expansion', expansion.toJson());
    }
    await batch.commit(noResult: true);
  }

  Future<List<ExpansionDBModel>> getExpansionList() async {
    await openDb();
    final List<Map<String, dynamic>> maps = await _database.query('expansion');
    return List.generate(maps.length, (i) {
      return ExpansionDBModel.fromDB(maps[i]);
    });
  }

  Future<int> updateExpansion(ExpansionDBModel expansion) async {
    await openDb();
    return await _database.update('expansion', expansion.toJson(),
        where: "id = ?", whereArgs: [expansion.id]);
  }

  Future<int> deleteExpansionById(String id) async {
    await openDb();
    return await _database
        .delete('expansion', where: "id = ?", whereArgs: [id]);
  }

  Future<ExpansionDBModel> getExpansionById(String id) async {
    await openDb();
    final List<Map<String, dynamic>> maps =
        await _database.query('expansion', where: "id = ?", whereArgs: [id]);
    return ExpansionDBModel.fromDB(maps.first);
  }
}
