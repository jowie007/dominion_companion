import 'dart:async';
import 'dart:developer';
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
        "CREATE TABLE deck("
        "id INTEGER PRIMARY KEY, "
        "name STRING, "
        "image STRING, "
        "rating STRING, "
        "cardIds STRING, "
        "creationDate STRING, "
        "editDate STRING)",
      );
    });
    return _database;
  }

  Future<int> insertDeck(DeckDBModel deck) async {
    await openDb();
    return await _database.insert('deck', deck.toJson());
  }

  Future<List<String>> getAllDeckNames() async {
    await openDb();
    final List<Map<String, dynamic>> maps =
        await _database.query('deck', columns: ["name"]);
    return List.generate(maps.length, (i) {
      return maps[i]["name"];
    });
  }

  Future<List<DeckDBModel>> getDeckList(bool sortAsc, String sortKey) async {
    await openDb();
    final List<Map<String, dynamic>> maps = await _database.query('deck',
        orderBy: "$sortKey ${sortAsc ? 'ASC' : 'DESC'}");
    return List.generate(maps.length, (i) {
      return DeckDBModel.fromDB(maps[i]);
    });
  }

  Future<DeckDBModel?> getDeckByPosition(
      int position, bool sortAsc, String sortKey) async {
    await openDb();
    final List<Map<String, dynamic>> maps = await _database
        .rawQuery('SELECT * FROM deck LIMIT 1 OFFSET $position;');
    return maps.isNotEmpty ? DeckDBModel.fromDB(maps.first) : null;
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

  Future<int> renameDeck(int id, String newName) async {
    await openDb();
    return await _database.update('deck',
        {"name": newName, "editDate": DateTime.now().millisecondsSinceEpoch},
        where: "id = ?", whereArgs: [id]);
  }
}
