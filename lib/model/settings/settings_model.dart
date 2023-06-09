import 'package:dominion_comanion/database/model/settings/settings_db_model.dart';

class SettingsModel {
  late String sortKey;
  late bool sortAsc;

  SettingsModel.fromJson(Map<String, dynamic> json) {
    sortKey = json['sortKey'];
    sortAsc = json['sortAsc'] ?? false;
  }

  SettingsModel.fromDBModel(SettingsDBModel dbModel) {
    sortKey = dbModel.sortKey;
    sortAsc = dbModel.sortAsc;
  }
}
