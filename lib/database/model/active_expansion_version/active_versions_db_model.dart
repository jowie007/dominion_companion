import 'package:dominion_companion/model/active_expansion_version/active_expansion_version_model.dart';

class ActiveExpansionVersionDBModel {
  late String expansionId;

  ActiveExpansionVersionDBModel.fromDB(Map<String, dynamic> dbData) {
    expansionId = dbData['expansionId'];
  }

  ActiveExpansionVersionDBModel.fromModel(ActiveExpansionVersionModel model) {
    expansionId = model.expansionId;
  }

  Map<String, dynamic> toJson() => {
        'expansionId': expansionId,
      };
}
