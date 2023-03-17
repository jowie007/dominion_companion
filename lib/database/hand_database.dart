import 'dart:async';
import 'package:dominion_comanion/database/model/hand/hand_db_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// https://docs.flutter.dev/cookbook/persistence/sqlite
// https://medium.com/flutterdevs/sql-database-storage-using-sqlite-in-flutter-6e2fdcc8cfb7
class HandDatabase {
  late Database _database;

  Future openDb() async {
    _database = await openDatabase(join(await getDatabasesPath(), "hand.db"),
        version: 1, onCreate: (Database db, int version) async {
      await db.execute(
        "CREATE TABLE hand("
        "id STRING PRIMARY KEY, "
        "always BOOL, "
        "cards STRING, "
        "additionalCards STRING, "
        "content STRING, "
        "additionalContent STRING, "
        "whenDeckConsistsOfXCardsOfExpansionCount NUMBER)",
      );
    });
    return _database;
  }

  Future<int> deleteHandTable() async {
    await openDb();
    return await _database.delete('hand');
  }

  Future<int> insertHand(HandDBModel hand) async {
    await openDb();
    return await _database.insert('hand', hand.toJson());
  }

  Future<List<HandDBModel>> getHandList() async {
    await openDb();
    final List<Map<String, dynamic>> maps = await _database.query('hand');
    return List.generate(maps.length, (i) {
      return HandDBModel.fromDB(maps[i]);
    });
  }

  Future<List<HandDBModel>> getAlwaysHandList() async {
    await openDb();
    final List<Map<String, dynamic>> maps =
        await _database.rawQuery('SELECT * FROM hand WHERE always=?', [1]);
    return List.generate(maps.length, (i) {
      return HandDBModel.fromDB(maps[i]);
    });
  }

  Future<List<HandDBModel>> getWhenDeckConsistsOfXCards() async {
    await openDb();
    final List<Map<String, dynamic>> maps = await _database.rawQuery(
        'SELECT * FROM hand WHERE length(whenDeckConsistsOfXCards) > 0');
    return List.generate(maps.length, (i) {
      return HandDBModel.fromDB(maps[i]);
    });
  }

  Future<HandDBModel> getHandById(String id) async {
    await openDb();
    final List<Map<String, dynamic>> maps = await _database
        .rawQuery('SELECT * FROM hand WHERE id LIKE ?', ["$id%"]);
    return HandDBModel.fromDB(maps.first);
  }

  Future<HandDBModel?> getHandByExpansionId(String id) async {
    await openDb();
    final List<Map<String, dynamic>> maps = await _database
        .rawQuery('SELECT * FROM hand WHERE id LIKE ?', ["$id%"]);
    return maps.isNotEmpty ? HandDBModel.fromDB(maps.first) : null;
  }

  Future<int> updateHand(HandDBModel hand) async {
    await openDb();
    return await _database
        .update('hand', hand.toJson(), where: "id = ?", whereArgs: [hand.id]);
  }

  Future<int> deleteHandById(String id) async {
    await openDb();
    return await _database.delete('hand', where: "id = ?", whereArgs: [id]);
  }
}
