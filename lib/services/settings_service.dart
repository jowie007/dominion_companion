import 'dart:developer';

import 'package:dominion_comanion/database/card_database.dart';
import 'package:dominion_comanion/database/model/deck/deck_db_model.dart';
import 'package:dominion_comanion/database/model/settings/settings_db_model.dart';
import 'package:dominion_comanion/database/settings_database.dart';
import 'package:dominion_comanion/model/card/card_model.dart';
import 'package:dominion_comanion/model/card/card_type_infos.dart';
import 'package:dominion_comanion/model/content/content_model.dart';
import 'package:dominion_comanion/model/deck/deck_model.dart';
import 'package:dominion_comanion/model/end/end_model.dart';
import 'package:dominion_comanion/model/hand/hand_model.dart';
import 'package:dominion_comanion/model/settings/settings_model.dart';
import 'package:dominion_comanion/services/card_service.dart';
import 'package:dominion_comanion/services/content_service.dart';
import 'package:dominion_comanion/services/deck_service.dart';
import 'package:dominion_comanion/services/end_service.dart';
import 'package:dominion_comanion/services/hand_service.dart';

// TODO Einmal initial laden und erst dann weitermachen
class SettingsService {
  static final SettingsService _settingsService = SettingsService._internal();

  final SettingsDatabase _settingsDatabase = SettingsDatabase();

  late SettingsModel settings;

  factory SettingsService() {
    return _settingsService;
  }

  SettingsService._internal();

  Future<void> initSettings() async {
    await _settingsDatabase.initDatabase();
  }

  Future<void> loadSettings() async {
    settings = await getSettings();
  }

  Future<SettingsModel> getSettings() async {
    return SettingsModel.fromDBModel(await _settingsDatabase.getSettings());
  }

  SettingsModel getCachedSettings() {
    return settings;
  }

  void setCachedSettings(SettingsModel settingsModel) {
    settings = settingsModel;
    updateSettingsTable(settings);
  }

  void setCachedSettingsSortKey(String sortKey) {
    settings.sortKey = sortKey;
    updateSettingsTable(settings);
  }

  void setCachedSettingsSortAsc(bool sortAsc) {
    settings.sortAsc = sortAsc;
    updateSettingsTable(settings);
  }

  Future<int> deleteSettingsTable() {
    return _settingsDatabase.deleteSettingsTable();
  }

  Future<int> updateSettingsTable(SettingsModel settings) {
    return _settingsDatabase.updateSettings(SettingsDBModel.fromModel(settings));
  }
}
