import 'package:dominion_companion/database/model/active_expansion_version/active_versions_db_model.dart';

class ActiveExpansionVersionModel {
  late String prefix;
  late String version;
  late int priority;

  ActiveExpansionVersionModel(this.prefix, this.version);

  ActiveExpansionVersionModel.fromJson(Map<String, dynamic> json) {
    prefix = json['prefix'];
    version = json['version'];
    priority = json['priority'];
  }

  ActiveExpansionVersionModel.fromDBModel(ActiveExpansionVersionDBModel dbModel) {
    prefix = dbModel.prefix;
    version = dbModel.version;
    priority = dbModel.priority;
  }
}
