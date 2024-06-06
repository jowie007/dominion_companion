import 'package:dominion_companion/model/settings/settings_model.dart';

class SettingsDBModel {
  late String version;
  late String sortKey;
  late bool sortAsc;
  late bool playAudio;
  late bool gyroscopeCardPopup;
  late bool loadingSuccess;

  SettingsDBModel.fromDB(Map<String, dynamic> dbData) {
    version = dbData['version'];
    sortKey = dbData['sortKey'];
    sortAsc = dbData['sortAsc'] != null ? dbData['sortAsc'] > 0 : false;
    playAudio = dbData['playAudio'] != null ? dbData['playAudio'] > 0 : false;
    gyroscopeCardPopup = dbData['gyroscopeCardPopup'] != null
        ? dbData['gyroscopeCardPopup'] > 0
        : false;
    loadingSuccess =
        dbData['loadingSuccess'] != null ? dbData['loadingSuccess'] > 0 : false;
  }

  SettingsDBModel.fromModel(SettingsModel model) {
    version = model.version;
    sortKey = model.sortKey;
    sortAsc = model.sortAsc;
    playAudio = model.playAudio;
    gyroscopeCardPopup = model.gyroscopeCardPopup;
    loadingSuccess = model.loadingSuccess;
  }

  Map<String, dynamic> toJson() => {
        'version': version,
        'sortKey': sortKey,
        'sortAsc': sortAsc ? 1 : 0,
        'playAudio': playAudio ? 1 : 0,
        'gyroscopeCardPopup': gyroscopeCardPopup ? 1 : 0,
        'loadingSuccess': loadingSuccess ? 1 : 0,
      };
}
