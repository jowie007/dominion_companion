import 'dart:async';

import 'package:dominion_companion/database/model/settings/settings_db_model.dart';
import 'package:package_info_plus/package_info_plus.dart';
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
          "version STRING, "
          "sortKey STRING, "
          "sortAsc BOOL, "
          "playAudio BOOL, "
          "gyroscopeCardPopup BOOL, "
          "loadingSuccess BOOL)");
    });
    return _database;
  }

  Future<int> deleteSettingsTable() async {
    await openDb();
    return await _database.delete('settings');
  }

  Future<int> initDatabase() async {
    await openDb();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return await _database.insert('settings', {
      "id": "settings",
      "version": packageInfo.version,
      "sortKey": "creationDate",
      "sortAsc": 1,
      "playAudio": 1,
      "gyroscopeCardPopup": 0,
      "loadingSuccess": 0
    });
  }

  Future<SettingsDBModel?> getSettings() async {
    await openDb();
    final List<Map<String, dynamic>> maps = await _database
        .rawQuery('SELECT * FROM settings WHERE id LIKE ?', ["settings%"]);
    return maps.isNotEmpty ? SettingsDBModel.fromDB(maps.first) : null;
  }

  Future<int> updateSettings(SettingsDBModel settings) async {
    await openDb();
    return await _database.update('settings', settings.toJson(),
        where: "id = ?", whereArgs: ["settings"]);
  }

  Future<void> deleteDb() async {
    String path = join(await getDatabasesPath(), "settings.db");
    await deleteDatabase(path);
  }
}
