import 'dart:async';
import 'package:dominion_comanion/database/model/card/card_db_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// https://docs.flutter.dev/cookbook/persistence/sqlite
// https://medium.com/flutterdevs/sql-database-storage-using-sqlite-in-flutter-6e2fdcc8cfb7
class CardDatabase {
  late Database _database;

  Future openDb() async {
    _database = await openDatabase(join(await getDatabasesPath(), "card.db"),
        version: 1, onCreate: (Database db, int version) async {
      await db.execute(
        "CREATE TABLE card("
        "id STRING PRIMARY KEY, "
        "name STRING, "
        "action BOOL, "
        "attack BOOL, "
        "curse BOOL, "
        "duration BOOL, "
        "treasure BOOL, "
        "victory bool, "
        "coin STRING, "
        "debt STRING, "
        "potion STRING, "
        "text STRING)",
      );
    });
    return _database;
  }

  Future<int> insertCard(CardDBModel card) async {
    await openDb();
    return await _database.insert('card', card.toJson());
  }

  Future<List<CardDBModel>> getCardList() async {
    await openDb();
    final List<Map<String, dynamic>> maps = await _database.query('card');
    return List.generate(maps.length, (i) {
      return CardDBModel.fromJson(maps[i]);
    });
  }

  Future<int> updateCard(CardDBModel card) async {
    await openDb();
    return await _database
        .update('card', card.toJson(), where: "id = ?", whereArgs: [card.id]);
  }

  Future<int> deleteCardById(String id) async {
    await openDb();
    return await _database.delete('card', where: "id = ?", whereArgs: [id]);
  }
}
