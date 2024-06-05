import 'package:dominion_companion/database/model/active_expansion_version/active_versions_db_model.dart';

class ActiveExpansionVersionModel {
  late String expansionId;

  ActiveExpansionVersionModel(this.expansionId);

  ActiveExpansionVersionModel.fromJson(Map<String, dynamic> json) {
    expansionId = json['expansionId'];
  }

  ActiveExpansionVersionModel.fromDBModel(ActiveExpansionVersionDBModel dbModel) {
    expansionId = dbModel.expansionId;
  }
}
