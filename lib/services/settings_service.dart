import 'dart:developer';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:dominion_companion/database/model/settings/settings_db_model.dart';
import 'package:dominion_companion/database/settings_database.dart';
import 'package:dominion_companion/model/settings/settings_model.dart';
import 'package:dominion_companion/services/active_expansion_version_service.dart';
import 'package:dominion_companion/services/card_service.dart';
import 'package:dominion_companion/services/content_service.dart';
import 'package:dominion_companion/services/deck_service.dart';
import 'package:dominion_companion/services/end_service.dart';
import 'package:dominion_companion/services/expansion_service.dart';
import 'package:dominion_companion/services/file_service.dart';
import 'package:dominion_companion/services/hand_service.dart';
import 'package:dominion_companion/services/selected_card_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

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

  FileService fileService = FileService();

  String? downloadUrl;

  final String releasesUrl =
      'https://github.com/jowie007/dominion_companion/releases';

  // Adjust version in pubspec.yaml
  Future<void> initializeApp(
      {deleteSettings = false,
      deleteDecks = false,
      checkCardNamesAndImages = false,
      initializeExpansions = false}) async {
    fileService.initialize();
    if (deleteSettings) {
      await deleteDb()
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

    if (deleteDecks) {
      await DeckService().deleteDb();
    }

    await PackageInfo.fromPlatform().then((packageInfo) async {
      if (settings!.version != packageInfo.version ||
          initializeExpansions ||
          !settings!.loadingSuccess) {
        await updateLoadingSuccess(false);
        await SelectedCardService().deleteSelectedCards();
        await ActiveExpansionVersionService().deleteDb();
        await ExpansionService().deleteDb();
        await CardService().deleteCardTable();
        await ContentService().deleteContentTable();
        await HandService().deleteHandTable();
        await HandService().deleteHandTable();
        await EndService().deleteEndTable();
        await ExpansionService().loadJsonExpansionsIntoDB();
        await ActiveExpansionVersionService().fillActiveExpansionVersionTable();
        await updateVersion(packageInfo.version);
        await updateLoadingSuccess(true);
      }
    }).catchError((e) {
      // Check if something is going wrong
    });

    if (checkCardNamesAndImages) {
      CardService().testCardNamesAndImages();
    }
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

  void setCachedSettingsPlayAudio(bool playAudio) {
    settings!.playAudio = playAudio;
    notifier.value = !notifier.value;
    updateSettingsTable(settings!);
  }

  void setCachedSettingsGyroscopeCardPopup(bool gyroscopeCardPopup) {
    settings!.gyroscopeCardPopup = gyroscopeCardPopup;
    notifier.value = !notifier.value;
    updateSettingsTable(settings!);
  }

  String? getDownloadUrl() {
    return downloadUrl;
  }

  Future<void> deleteDb() async {
    _settingsDatabase.deleteDb();
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

  Future<bool?> checkForUpdates() async {
    final response = await http.get(Uri.parse(
        'https://api.github.com/repos/jowie007/dominion_companion/releases/latest'));

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      downloadUrl = jsonResponse['assets'][0]['browser_download_url'];
      return jsonResponse['tag_name'] != settings!.version;
    } else {
      return null;
    }
  }

  downloadUpdate() async {
    if (downloadUrl != null) {
      var uri = Uri.parse(downloadUrl!);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        throw 'Could not launch $downloadUrl';
      }
    }
  }

  shareApp(BuildContext context) {
    String url = downloadUrl ?? releasesUrl;
    String shareText =
        "Erstelle Dominion Decks nach deinen Vorlieben! Lade dir jetzt die neueste Version von Julia's Dominion Companion runter:"
        '\n$url';
    if (downloadUrl != null) {
      shareText += '\n\n'
          'Für mehr Infos besuche diese Seite:'
          '\n$releasesUrl';
    }
    Share.share(shareText);
  }
}
