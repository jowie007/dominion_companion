import 'package:dominion_comanion/model/end/end_model.dart';

class EndDBModel {
  late String id;
  late bool always;
  late List<String> emptyCards;
  late List<String> additionalEmptyCards;
  late int? emptyCount;

  EndDBModel.fromDB(Map<String, dynamic> dbData) {
    id = dbData['id'];
    always = dbData['always'] != null ? dbData['always'] > 0 : false;
    emptyCards =
        dbData['emptyCards'] != '' ? dbData['emptyCards'].split(',') : [];
    additionalEmptyCards = dbData['additionalEmptyCards'] != ''
        ? dbData['additionalEmptyCards'].split(',')
        : [];
    emptyCount = dbData['emptyCount'];
  }

  EndDBModel.fromModel(EndModel model) {
    id = model.id;
    always = model.always;
    emptyCards = model.emptyCards;
    additionalEmptyCards = model.additionalEmptyCards;
    emptyCount = model.emptyCount;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'always': always ? 1 : 0,
        'emptyCards': emptyCards.join(","),
        'additionalEmptyCards': additionalEmptyCards.join(","),
        'emptyCount': emptyCount,
      };
}
