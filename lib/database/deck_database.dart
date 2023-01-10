import 'dart:async';
import 'package:dominion_comanion/model/deck/deck_model.dart';
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
            "CREATE TABLE deck(name STRING PRIMARY KEY)",
          );
        });
    return _database;
  }

  Future<int> insertDeck(Deck deck) async {
    await openDb();
    return await _database.insert('deck', deck.toJson());
  }

  Future<List<Deck>> getDeckList() async {
    await openDb();
    final List<Map<String, dynamic>> maps = await _database.query('deck');

    return List.generate(maps.length, (i) {
      return Deck(
        id: maps[i]['id'],
        name: maps[i]['name'],
        cardIds: maps[i]['cardIds'],
      );
    });
  }

  Future<int> updateDeck(Deck deck) async {
    await openDb();
    return await _database.update('deck', deck.toJson(),
        where: "name = ?", whereArgs: [deck.name]);
  }

  Future<int> deleteDeckById(int id) async {
    await openDb();
    return await _database.delete('deck', where: "id = ?", whereArgs: [id]);
  }
}
