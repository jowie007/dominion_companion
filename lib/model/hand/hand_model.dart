import 'package:dominion_comanion/database/model/hand/hand_db_model.dart';

class HandModel {
  late String id;
  late bool always;
  late Map<String, int>? cardIdCountMap;
  late Map<String, int>? additionalCardIdCountMap;
  late Map<String, int>? contentIdCountMap;
  late Map<String, int>? additionalContentIdsCountMap;

  HandModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    always = json['always'] ?? false;
    cardIdCountMap =
        json['cards'] != null ? Map<String, int>.from(json['cards']) : null;
    additionalCardIdCountMap = json['additionalCards'] != null
        ? Map<String, int>.from(json['additionalCards'])
        : null;
    contentIdCountMap =
        json['content'] != null ? Map<String, int>.from(json['content']) : null;
    additionalContentIdsCountMap = json['additionalContent'] != null
        ? Map<String, int>.from(json['additionalContent'])
        : null;
  }

  HandModel.fromDBModel(HandDBModel dbModel) {
    id = dbModel.id;
    always = dbModel.always;
    cardIdCountMap = dbModel.cardIdCountMap;
    additionalCardIdCountMap = dbModel.additionalCardIdCountMap;
    contentIdCountMap = dbModel.contentIdCountMap;
    additionalContentIdsCountMap = dbModel.additionalContentIdsCountMap;
  }
}
