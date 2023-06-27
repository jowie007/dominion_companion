import 'package:dominion_companion/model/settings/settings_model.dart';

class SettingsDBModel {
  late String version;
  late String sortKey;
  late bool sortAsc;

  SettingsDBModel.fromDB(Map<String, dynamic> dbData) {
    version = dbData['version'];
    sortKey = dbData['sortKey'];
    sortAsc = dbData['sortAsc'] != null ? dbData['sortAsc'] > 0 : false;
  }

  SettingsDBModel.fromModel(SettingsModel model) {
    version = model.version;
    sortKey = model.sortKey;
    sortAsc = model.sortAsc;
  }

  Map<String, dynamic> toJson() => {
        'version': version,
        'sortKey': sortKey,
        'sortAsc': sortAsc ? 1 : 0,
      };
}
