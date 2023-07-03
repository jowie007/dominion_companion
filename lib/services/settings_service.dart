import 'dart:developer';

import 'package:dominion_companion/database/model/settings/settings_db_model.dart';
import 'package:dominion_companion/database/settings_database.dart';
import 'package:dominion_companion/model/settings/settings_model.dart';
import 'package:dominion_companion/services/card_service.dart';
import 'package:dominion_companion/services/content_service.dart';
import 'package:dominion_companion/services/end_service.dart';
import 'package:dominion_companion/services/expansion_service.dart';
import 'package:dominion_companion/services/hand_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingsService {
  static final SettingsService _settingsService = SettingsService._internal();

  final SettingsDatabase _settingsDatabase = SettingsDatabase();

  SettingsModel? settings;

  factory SettingsService() {
    return _settingsService;
  }

  ValueNotifier<bool> notifier = ValueNotifier(false);

  SettingsService._internal();

  Exception? initException;

  // Adjust version in pubspec.yaml
  Future<void> initializeApp(
      {deleteSettings = false,
      checkCardNames = false,
      initializeExpansions = false}) async {
    if (deleteSettings) {
      await deleteSettingsTable()
          .then((value) => initDatabase())
          .then((value) => initCachedSettings())
          .then((value) => log("ALL SETTINGS LOADED"));
    }

    await initCachedSettings();
    if (settings == null) {
      log("SETTING IS NULL");
      await initDatabase();
      await initCachedSettings();
    }
    await PackageInfo.fromPlatform().then((packageInfo) async {
      if (settings!.version != packageInfo.version ||
          initializeExpansions ||
          !settings!.loadingSuccess) {
        await updateLoadingSuccess(false);
        await ExpansionService()
            .deleteExpansionTable()
            .then((value) => CardService().deleteCardTable())
            .then((value) => ContentService().deleteContentTable())
            .then((value) => HandService().deleteHandTable())
            .then((value) => EndService().deleteEndTable())
            .then((value) => ExpansionService().loadJsonExpansionsIntoDB());
        await updateVersion(packageInfo.version);
        await updateLoadingSuccess(true);
      }
    });

    if (checkCardNames) {
      testCardNames();
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

  Future<SettingsModel?> getSettings() async {
    final settings = await _settingsDatabase.getSettings();
    return settings != null ? SettingsModel.fromDBModel(settings) : null;
  }

  SettingsModel getCachedSettings() {
    return settings!;
  }

  void setCachedSettings(SettingsModel settingsModel) {
    settings = settingsModel;
    notifier.value = !notifier.value;
    updateSettingsTable(settings!);
  }

  void setCachedSettingsSortKey(String sortKey) {
    settings!.sortKey = sortKey;
    notifier.value = !notifier.value;
    updateSettingsTable(settings!);
  }

  void setCachedSettingsSortAsc(bool sortAsc) {
    settings!.sortAsc = sortAsc;
    notifier.value = !notifier.value;
    updateSettingsTable(settings!);
  }

  Future<int> deleteSettingsTable() {
    return _settingsDatabase.deleteSettingsTable();
  }

  Future<int> updateCachedSettings(String sortKey, bool sortAsc) {
    settings!.sortKey = sortKey;
    settings!.sortAsc = sortAsc;
    notifier.value = !notifier.value;
    return _settingsDatabase
        .updateSettings(SettingsDBModel.fromModel(settings!));
  }

  Future<int> updateVersion(String version) {
    settings!.version = version;
    notifier.value = !notifier.value;
    return _settingsDatabase
        .updateSettings(SettingsDBModel.fromModel(settings!));
  }

  Future<int> updateLoadingSuccess(bool loadingSuccess) {
    settings!.loadingSuccess = loadingSuccess;
    notifier.value = !notifier.value;
    return _settingsDatabase
        .updateSettings(SettingsDBModel.fromModel(settings!));
  }

  Future<int> updateSettingsTable(SettingsModel settingsModel) {
    return _settingsDatabase
        .updateSettings(SettingsDBModel.fromModel(settings!));
  }
}
