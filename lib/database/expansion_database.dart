import 'dart:async';
import 'dart:developer';
import 'package:dominion_comanion/database/model/expansion/expansion_db_model.dart';
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
        "CREATE TABLE expansion(id STRING PRIMARY KEY, name STRING, version STRING, cardIds STRING, contentIds STRING, handIds STRING, endId STRING)",
      );
    });
    return _database;
  }

  Future<int> deleteExpansionTable() async {
    await openDb();
    return await _database.delete('expansion');
  }

  Future<int> insertExpansion(ExpansionDBModel expansion) async {
    await openDb();
    return await _database.insert('expansion', expansion.toJson());
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
}
