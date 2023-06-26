import 'dart:developer';

import 'package:dominion_comanion/database/model/settings/settings_db_model.dart';
import 'package:dominion_comanion/database/settings_database.dart';
import 'package:dominion_comanion/model/settings/settings_model.dart';
import 'package:dominion_comanion/services/card_service.dart';
import 'package:dominion_comanion/services/content_service.dart';
import 'package:dominion_comanion/services/end_service.dart';
import 'package:dominion_comanion/services/expansion_service.dart';
import 'package:dominion_comanion/services/hand_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingsService {
  static final SettingsService _settingsService = SettingsService._internal();

  final SettingsDatabase _settingsDatabase = SettingsDatabase();

  late SettingsModel settings;

  factory SettingsService() {
    return _settingsService;
  }

  ValueNotifier<bool> notifier = ValueNotifier(false);

  SettingsService._internal();

  Exception? initException;

  Future<void> initializeApp(
      {deleteSettings = false, checkCardNames = false}) async {
    await initCachedSettings();
    if(settings == null) {
      await initDatabase();
      await initCachedSettings();
    }
    PackageInfo.fromPlatform().then((packageInfo) async {
      if (settings.version != packageInfo.version) {
        await ExpansionService()
            .deleteExpansionTable()
            .then((value) => CardService().deleteCardTable())
            .then((value) => ContentService().deleteContentTable())
            .then((value) => HandService().deleteHandTable())
            .then((value) => EndService().deleteEndTable())
            .then((value) => ExpansionService().loadJsonExpansionsIntoDB())
            .then((value) => log("ALL EXPANSIONS LOADED"));
        updateVersion(packageInfo.version);
      }
    });

    if (checkCardNames) {
      testCardNames();
    }

    if (deleteSettings) {
      deleteSettingsTable()
          .then((value) => initDatabase())
          .then((value) => initCachedSettings())
          .then((value) => log("ALL SETTINGS LOADED"));
    }
  }

  void testCardNames() async {
    CardService().getAllCards().then(
      (cards) async {
        for (var card in cards) {
          var split = card.id.split("-");
          if (split[1] != "set") {
            try {
              await rootBundle
                  .load('assets/cards/full/${split[0]}/${split[2]}.png');
            } catch (_) {
              log("${card.id} not found");
            }
          }
        }
      },
    );
  }

  Future<void> initDatabase() async {
    await _settingsDatabase.initDatabase();
  }

  Future<void> initCachedSettings() async {
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
    notifier.value = !notifier.value;
    updateSettingsTable(settings);
  }

  void setCachedSettingsSortKey(String sortKey) {
    settings.sortKey = sortKey;
    notifier.value = !notifier.value;
    updateSettingsTable(settings);
  }

  void setCachedSettingsSortAsc(bool sortAsc) {
    settings.sortAsc = sortAsc;
    notifier.value = !notifier.value;
    updateSettingsTable(settings);
  }

  Future<int> deleteSettingsTable() {
    return _settingsDatabase.deleteSettingsTable();
  }

  Future<int> updateCachedSettings(String sortKey, bool sortAsc) {
    settings.sortKey = sortKey;
    settings.sortAsc = sortAsc;
    notifier.value = !notifier.value;
    return _settingsDatabase
        .updateSettings(SettingsDBModel.fromModel(settings));
  }

  Future<int> updateVersion(String version) {
    settings.version = version;
    notifier.value = !notifier.value;
    return _settingsDatabase
        .updateSettings(SettingsDBModel.fromModel(settings));
  }

  Future<int> updateSettingsTable(SettingsModel settingsModel) {
    return _settingsDatabase
        .updateSettings(SettingsDBModel.fromModel(settings));
  }
}
