import 'package:dominion_companion/database/model/end/end_db_model.dart';

class EndModel {
  late String id;
  late bool always;
  late List<String> emptyCards;
  late List<String> additionalEmptyCards;
  late int? emptyCount;

  EndModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    always = json['always'] ?? false;
    emptyCards =
        json['emptyCards'] != null ? List<String>.from(json['emptyCards']) : [];
    additionalEmptyCards = json['additionalEmptyCards'] != null
        ? List<String>.from(json['additionalEmptyCards'])
        : [];
    emptyCount = json['emptyCount'] != null
        ? int.parse(json['emptyCount'].toString())
        : null;
  }

  EndModel.fromDBModel(EndDBModel dbModel) {
    id = dbModel.id;
    always = dbModel.always;
    emptyCards = dbModel.emptyCards;
    additionalEmptyCards = dbModel.additionalEmptyCards;
    emptyCount = dbModel.emptyCount;
  }

  List<String> getAllEmptyCardIds() {
    return [...emptyCards, ...additionalEmptyCards];
  }
}
