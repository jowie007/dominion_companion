import 'dart:async';
import 'package:dominion_comanion/database/model/settings/settings_db_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SettingsDatabase {
  late Database _database;

  Future openDb() async {
    _database = await openDatabase(
        join(await getDatabasesPath(), "settings.db"),
        version: 1, onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE settings("
          "id STRING PRIMARY KEY, "
          "sortKey STRING, "
          "sortAsc BOOL)");
    });
    return _database;
  }

  Future<int> deleteSettingsTable() async {
    await openDb();
    return await _database.delete('settings');
  }

  Future<int> initDatabase() async {
    await openDb();
    return await _database.insert('settings',
        {"id": "settings", "sortKey": "creationDate", "sortAsc": 1});
  }

  Future<SettingsDBModel> getSettings() async {
    await openDb();
    final List<Map<String, dynamic>> maps = await _database
        .rawQuery('SELECT * FROM settings WHERE id LIKE ?', ["settings%"]);
    return SettingsDBModel.fromDB(maps.first);
  }

  Future<int> updateSettings(SettingsDBModel settings) async {
    await openDb();
    return await _database.update('settings', settings.toJson(),
        where: "id = ?", whereArgs: ["settings"]);
  }
}
