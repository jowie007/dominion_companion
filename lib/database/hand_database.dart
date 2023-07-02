import 'dart:async';
import 'package:dominion_companion/database/model/hand/hand_db_model.dart';
import 'package:dominion_companion/model/hand/hand_type_enum.dart';
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
        "elements STRING, "
        "elementsReplace STRING, "
        "additionalElements STRING, "
        "whenDeckConsistsOfXCards STRING, "
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

  Future<void> insertHands(List<HandDBModel> hands) async {
    await openDb();
    var batch = _database.batch();
    for (var hand in hands) {
      batch.insert('hand', hand.toJson());
    }
    await batch.commit(noResult: true);
  }

  Future<List<HandDBModel>> getHandList() async {
    await openDb();
    final List<Map<String, dynamic>> maps = await _database.query('hand');
    return List.generate(maps.length, (i) {
      return HandDBModel.fromDB(maps[i]);
    });
  }

  Future<List<HandDBModel>> getAlwaysHandListByType(HandTypeEnum type) async {
    await openDb();
    final List<Map<String, dynamic>> maps = await _database.rawQuery(
        'SELECT * FROM hand WHERE always=? AND id LIKE ?',
        [1, "%${type.dbString}%"]);
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

  Future<List<HandDBModel>> getHandsByExpansionIdAndType(
      String expansionId, HandTypeEnum handTypeEnum) async {
    await openDb();
    final List<Map<String, dynamic>> maps = await _database.rawQuery(
        'SELECT * FROM hand WHERE id LIKE ?',
        ["$expansionId-${handTypeEnum.dbString}%"]);
    return List.generate(maps.length, (i) {
      return HandDBModel.fromDB(maps[i]);
    });
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
