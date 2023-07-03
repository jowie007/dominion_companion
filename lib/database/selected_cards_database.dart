import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// https://docs.flutter.dev/cookbook/persistence/sqlite
// https://medium.com/flutterdevs/sql-database-storage-using-sqlite-in-flutter-6e2fdcc8cfb7
class SelectedCardDatabase {
  late Database _database;

  Future openDb() async {
    _database = await openDatabase(
        join(await getDatabasesPath(), "selectedCard.db"),
        version: 1, onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE selectedCard("
          "id STRING PRIMARY KEY)");
    });
    return _database;
  }

  Future<int> insertSelectedCardId(String selectedCardId) async {
    await openDb();
    return await _database.insert('selectedCard', {"id": selectedCardId});
  }

  Future<List<String>> getSelectedCardIdList() async {
    await openDb();
    final List<Map<String, dynamic>> maps =
        await _database.query('selectedCard');
    return List.generate(maps.length, (i) {
      return maps[i]['id'];
    });
  }

  Future<int> deleteSelectedCardId(String id) async {
    await openDb();
    return await _database
        .delete('selectedCard', where: "id = ?", whereArgs: [id]);
  }
}
