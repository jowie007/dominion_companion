import 'dart:async';
import 'dart:developer';
import 'package:dominion_comanion/database/model/end/end_db_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// https://docs.flutter.dev/cookbook/persistence/sqlite
// https://medium.com/flutterdevs/sql-database-storage-using-sqlite-in-flutter-6e2fdcc8cfb7
class EndDatabase {
  late Database _database;

  Future openDb() async {
    _database = await openDatabase(join(await getDatabasesPath(), "end.db"),
        version: 1, onCreate: (Database db, int version) async {
          await db.execute(
            "CREATE TABLE end("
                "id STRING PRIMARY KEY, "
                "always BOOL, "
                "emptyCards STRING, "
                "additionalEmptyCards STRING, "
                "emptyCount NUM)",
          );
        });
    return _database;
  }

  Future<int> deleteEndTable() async {
    await openDb();
    return await _database.delete('end');
  }

  Future<int> insertEnd(EndDBModel end) async {
    await openDb();
    return await _database.insert('end', end.toJson());
  }

  Future<List<EndDBModel>> getEndList() async {
    await openDb();
    final List<Map<String, dynamic>> maps = await _database.query('end');
    return List.generate(maps.length, (i) {
      return EndDBModel.fromDB(maps[i]);
    });
  }

  Future<List<EndDBModel>> getAlwaysEndList() async {
    await openDb();
    final List<Map<String, dynamic>> maps =
    await _database.rawQuery('SELECT * FROM end WHERE always=?', [1]);
    return List.generate(maps.length, (i) {
      return EndDBModel.fromDB(maps[i]);
    });
  }

  // https://www.sqlitetutorial.net/sqlite-like/
  Future<EndDBModel> getEndByEndId(String id) async {
    await openDb();
    final List<Map<String, dynamic>> maps =
    await _database.rawQuery('SELECT * FROM end WHERE id LIKE ?', ["$id%"]);
    return EndDBModel.fromDB(maps.first);
  }

  Future<EndDBModel?> getEndByExpansionId(String id) async {
    await openDb();
    final List<Map<String, dynamic>> maps =
    await _database.rawQuery('SELECT * FROM end WHERE id LIKE ?', ["$id%"]);
    return maps.isNotEmpty ? EndDBModel.fromDB(maps.first) : null;
  }

  Future<int> updateEnd(EndDBModel end) async {
    await openDb();
    return await _database
        .update('end', end.toJson(), where: "id LIKE ?", whereArgs: ["${end.id}%"]);
  }

  Future<int> deleteEndById(String id) async {
    await openDb();
    return await _database.delete('end', where: "id LIKE ?", whereArgs: ["$id%"]);
  }
}
