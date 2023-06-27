import 'dart:async';
import 'dart:developer';
import 'package:dominion_companion/database/model/card/card_db_model.dart';
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
        "always BOOL, "
        "whenDeckConsistsOfXCardTypesOfExpansion STRING, "
        "whenDeckConsistsOfXCards STRING, "
        "whenDeckConsistsOfXCardsOfExpansionCount NUMBER, "
        "whenDeckContainsPotions BOOL, "
        "supply BOOL, "
        "name STRING, "
        "setId STRING, "
        "parentId STRING, "
        "relatedCardIds STRING, "
        "invisible BOOL, "
        "cardTypes STRING, "
        "coin STRING, "
        "debt STRING, "
        "potion STRING, "
        "text STRING, "
        "count STRING)",
      );
    });
    return _database;
  }

  Future<int> deleteCardTable() async {
    await openDb();
    return await _database.delete('card');
  }

  Future<int> insertCard(CardDBModel card) async {
    await openDb();
    return await _database.insert('card', card.toJson());
  }

  Future<int?> getCardsLength() async {
    await openDb();
    return Sqflite.firstIntValue(
        await _database.rawQuery('SELECT COUNT(*) FROM card'));
  }

  Future<CardDBModel> getCardAtPosition(int position) async {
    await openDb();
    final List<Map<String, dynamic>> maps =
        await _database.rawQuery('SELECT * FROM card LIMIT 1 OFFSET $position');
    return CardDBModel.fromDB(maps.first);
  }

  Future<List<CardDBModel>> getCardList() async {
    await openDb();
    final List<Map<String, dynamic>> maps = await _database.query('card');
    return List.generate(maps.length, (i) {
      return CardDBModel.fromDB(maps[i]);
    });
  }

  Future<List<CardDBModel>> getCardsBySetId(String setId) async {
    await openDb();
    final List<Map<String, dynamic>> maps =
        await _database.rawQuery('SELECT * FROM card WHERE setId=?', [setId]);
    return List.generate(maps.length, (i) {
      return CardDBModel.fromDB(maps[i]);
    });
  }

  Future<List<CardDBModel>> getAlwaysCardList() async {
    await openDb();
    final List<Map<String, dynamic>> maps =
        await _database.rawQuery('SELECT * FROM card WHERE always=?', [1]);
    return List.generate(maps.length, (i) {
      return CardDBModel.fromDB(maps[i]);
    });
  }

  Future<List<CardDBModel>> getWhenDeckContainsPotionsCardList() async {
    await openDb();
    final List<Map<String, dynamic>> maps = await _database
        .rawQuery('SELECT * FROM card WHERE whenDeckContainsPotions=?', [1]);
    return List.generate(maps.length, (i) {
      return CardDBModel.fromDB(maps[i]);
    });
  }

  Future<List<CardDBModel>>
      getWhenDeckConsistsOfXCardTypesOfExpansionCards() async {
    await openDb();
    final List<Map<String, dynamic>> maps = await _database.rawQuery(
        'SELECT * FROM card WHERE length(whenDeckConsistsOfXCardTypesOfExpansion) > 0');
    return List.generate(maps.length, (i) {
      return CardDBModel.fromDB(maps[i]);
    });
  }

  Future<List<CardDBModel>> getWhenDeckConsistsOfXCards() async {
    await openDb();
    final List<Map<String, dynamic>> maps = await _database.rawQuery(
        'SELECT * FROM card WHERE length(whenDeckConsistsOfXCards) > 0');
    return List.generate(maps.length, (i) {
      return CardDBModel.fromDB(maps[i]);
    });
  }

  Future<List<CardDBModel>>
      getWhenDeckConsistsOfXCardsOfExpansionCount() async {
    await openDb();
    final List<Map<String, dynamic>> maps = await _database.rawQuery(
        'SELECT * FROM card WHERE whenDeckConsistsOfXCardsOfExpansionCount NOT NULL');
    return List.generate(maps.length, (i) {
      return CardDBModel.fromDB(maps[i]);
    });
  }

  Future<CardDBModel> getCardById(String id) async {
    await openDb();
    final List<Map<String, dynamic>> maps =
        await _database.rawQuery('SELECT * FROM card WHERE id=?', [id]);
    return CardDBModel.fromDB(maps.first);
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
