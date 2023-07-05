import 'package:dominion_companion/database/model/settings/settings_db_model.dart';

class SettingsModel {
  late String version;
  late String sortKey;
  late bool sortAsc;
  late bool playAudio;
  late bool loadingSuccess;

  SettingsModel.fromJson(Map<String, dynamic> json) {
    version = json['version'];
    sortKey = json['sortKey'];
    sortAsc = json['sortAsc'] ?? false;
    playAudio = json['playAudio'] ?? false;
    loadingSuccess = json['loadingSucess'] ?? false;
  }

  SettingsModel.fromDBModel(SettingsDBModel dbModel) {
    version = dbModel.version;
    sortKey = dbModel.sortKey;
    sortAsc = dbModel.sortAsc;
    playAudio = dbModel.playAudio;
    loadingSuccess = dbModel.loadingSuccess;
  }
}
