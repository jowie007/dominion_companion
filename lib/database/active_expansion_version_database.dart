import 'dart:async';

import 'package:dominion_companion/database/model/active_expansion_version/active_versions_db_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ActiveExpansionVersionDatabase {
  late Database _database;

  Future openDb() async {
    _database = await openDatabase(
        join(await getDatabasesPath(), "active_versions.db"),
        version: 1, onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE active_versions("
          "id STRING PRIMARY KEY, "
          "version STRING, "
          "priority INTEGER)");
    });
    return _database;
  }

  Future<int> deleteActiveVersionsTable() async {
    await openDb();
    return await _database.delete('active_versions');
  }

  // TODO: Implement initDatabase

  Future<List<ActiveExpansionVersionDBModel>?>
      getActiveExpansionVersions() async {
    await openDb();
    final List<Map<String, dynamic>> maps = await _database.rawQuery(
        'SELECT * FROM active_versions WHERE priority > 0 ORDER BY priority DESC');
    return maps.isNotEmpty
        ? List.generate(maps.length, (i) {
            return ActiveExpansionVersionDBModel.fromDB(maps[i]);
          })
        : null;
  }

// TODO: Implement updateActiveExpansionVersions
}
