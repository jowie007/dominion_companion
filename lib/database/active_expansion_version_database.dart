import 'dart:async';

import 'package:dominion_companion/database/model/active_expansion_version/active_versions_db_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ActiveExpansionVersionDatabase {
  late Database _database;

  Future openDb() async {
    _database = await openDatabase(
        join(await getDatabasesPath(), "active_expansion_versions.db"),
        version: 1, onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE active_expansion_versions("
          "expansionId STRING PRIMARY KEY)");
    });
    return _database;
  }

  Future<void> deleteDb() async {
    String path = join(await getDatabasesPath(), "active_expansion_versions.db");
    await deleteDatabase(path);
  }

  Future<List<ActiveExpansionVersionDBModel>?>
      getActiveExpansionVersions() async {
    await openDb();
    final List<Map<String, dynamic>> maps =
        await _database.rawQuery('SELECT * FROM active_expansion_versions');
    return maps.isNotEmpty
        ? List.generate(maps.length, (i) {
            return ActiveExpansionVersionDBModel.fromDB(maps[i]);
          })
        : null;
  }

  Future<List<String>> getActiveExpansionVersionIds() async {
    await openDb();
    final List<Map<String, dynamic>> maps =
        await _database.rawQuery('SELECT * FROM active_expansion_versions');
    return List.generate(maps.length, (i) {
      return maps[i]["expansionId"].toString();
    });
  }

  Future<int> insertOrUpdateActiveExpansionVersion(
      ActiveExpansionVersionDBModel activeExpansionVersionDBModel) async {
    await openDb();
    return await _database.insert(
        'active_expansion_versions', activeExpansionVersionDBModel.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> deleteActiveExpansionVersion(String expansionId) async {
    await openDb();
    return await _database.delete('active_expansion_versions',
        where: 'expansionId = ?', whereArgs: [expansionId]);
  }
}
