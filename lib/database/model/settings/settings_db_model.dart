import 'package:dominion_comanion/model/settings/settings_model.dart';

class SettingsDBModel {
  late String sortKey;
  late bool sortAsc;

  SettingsDBModel.fromDB(Map<String, dynamic> dbData) {
    sortKey = dbData['sortKey'];
    sortAsc = dbData['sortAsc'] != null ? dbData['sortAsc'] > 0 : false;
  }

  SettingsDBModel.fromModel(SettingsModel model) {
    sortKey = model.sortKey;
    sortAsc = model.sortAsc;
  }

  Map<String, dynamic> toJson() => {
    'sortKey': sortKey,
    'sortAsc': sortAsc ? 1 : 0,
  };
}
