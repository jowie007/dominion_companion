
import 'package:dominion_companion/database/active_expansion_version_database.dart';
import 'package:dominion_companion/database/model/active_expansion_version/active_versions_db_model.dart';
import 'package:dominion_companion/services/expansion_service.dart';

import '../model/active_expansion_version/active_expansion_version_model.dart';

class ActiveExpansionVersionService {
  late final ActiveExpansionVersionDatabase _activeExpansionVersionDatabase =
  ActiveExpansionVersionDatabase();
  late final ExpansionService _expansionService = ExpansionService();

  static final ActiveExpansionVersionService _selectedExpansionVersionService =
  ActiveExpansionVersionService._internal();

  factory ActiveExpansionVersionService() {
    return _selectedExpansionVersionService;
  }

  ActiveExpansionVersionService._internal();

  Future<void> deleteDb() async {
    _activeExpansionVersionDatabase.deleteDb();
  }

  Future<void> fillActiveExpansionVersionTable() async {
    List<String> activeExpansionIds =
    await _expansionService.getUniqueExpansionIdsWithHigherPriority();
    for (var activeExpansionId in activeExpansionIds) {
      _activeExpansionVersionDatabase.insertOrUpdateActiveExpansionVersion(
          ActiveExpansionVersionDBModel.fromModel(
              ActiveExpansionVersionModel(activeExpansionId)));
    }
  }

  Future<List<String>> getActiveExpansionVersionIds() async {
    return await _activeExpansionVersionDatabase.getActiveExpansionVersionIds();
  }

  Future<void> setActiveExpansionVersion(String? newVersion) async {
    if (newVersion != null) {
      await deleteActiveExpansionVersions(newVersion);
      _activeExpansionVersionDatabase.insertOrUpdateActiveExpansionVersion(
          ActiveExpansionVersionDBModel.fromModel(
              ActiveExpansionVersionModel(newVersion)));
    }
  }

  Future<void> deleteActiveExpansionVersions(String expansionId) async {
    await _expansionService
        .getExpansionIdsWithSamePrefix(expansionId)
        .then((expansionIds) async {
      for (var expansionId in expansionIds) {
        await _activeExpansionVersionDatabase
            .deleteActiveExpansionVersion(expansionId);
      }
    });
  }
}
