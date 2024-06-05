import 'package:dominion_companion/model/active_expansion_version/active_expansion_version_model.dart';

class ActiveExpansionVersionDBModel {
  late String prefix;
  late String version;
  late int priority;

  ActiveExpansionVersionDBModel.fromDB(Map<String, dynamic> dbData) {
    prefix = dbData['prefix'];
    version = dbData['version'];
    priority = dbData['priority'];
  }

  ActiveExpansionVersionDBModel.fromModel(ActiveExpansionVersionModel model) {
    prefix = model.prefix;
    version = model.version;
    priority = model.priority;
  }

  Map<String, dynamic> toJson() => {
        'prefix': prefix,
        'version': version,
        'priority': priority,
      };
}
