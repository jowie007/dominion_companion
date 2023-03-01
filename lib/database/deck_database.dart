import 'dart:async';
import 'package:dominion_comanion/database/model/deck/deck_db_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// https://docs.flutter.dev/cookbook/persistence/sqlite
// https://medium.com/flutterdevs/sql-database-storage-using-sqlite-in-flutter-6e2fdcc8cfb7
class DeckDatabase {
  late Database _database;

  Future openDb() async {
    _database = await openDatabase(join(await getDatabasesPath(), "deck.db"),
        version: 1, onCreate: (Database db, int version) async {
      await db.execute(
        "CREATE TABLE deck(name STRING PRIMARY KEY, cardIds STRING, content STRING, hand STRING, end STRING)",
      );
    });
    return _database;
  }

  Future<int> insertDeck(DeckDBModel deck) async {
    await openDb();
    return await _database.insert('deck', deck.toJson());
  }

  Future<List<DeckDBModel>> getDeckList() async {
    await openDb();
    final List<Map<String, dynamic>> maps = await _database.query('deck');
    return List.generate(maps.length, (i) {
      return DeckDBModel.fromDB(maps[i]);
    });
  }

  Future<int> updateDeck(DeckDBModel deck) async {
    await openDb();
    return await _database.update('deck', deck.toJson(),
        where: "name = ?", whereArgs: [deck.name]);
  }

  Future<int> deleteDeckByName(String name) async {
    await openDb();
    return await _database.delete('deck', where: "name = ?", whereArgs: [name]);
  }
}
