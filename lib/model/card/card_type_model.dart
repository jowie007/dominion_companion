import 'dart:collection';

import 'package:dominion_comanion/database/model/card/card_type_db_model.dart';

class CardTypeModel {
  late bool action;
  late bool attack;
  late bool curse;
  late bool duration;
  late bool treasure;
  late bool victory;
  var fileNameMap = {};

  CardTypeModel(this.action, this.attack, this.curse, this.duration,
      this.treasure, this.victory) {
    fileNameMap.addAll({
      'action': action,
      'attack': attack,
      'curse': curse,
      'duration': duration,
      'treasure': treasure,
      'victory': victory
    });
  }

  CardTypeModel.fromJson(Map<String, dynamic> json) {
    action = json['action'] as bool;
    attack = json['attack'] as bool;
    curse = json['curse'] as bool;
    duration = json['duration'] as bool;
    treasure = json['treasure'] as bool;
    victory = json['victory'] as bool;
  }

  CardTypeModel.fromDBModel(CardTypeDBModel dbModel) {
    action = dbModel.action;
    attack = dbModel.attack;
    curse = dbModel.curse;
    duration = dbModel.duration;
    treasure = dbModel.treasure;
    victory = dbModel.victory;
  }

  String getFileName() {
    String fileName = "";
    bool firstSet = false;
    fileNameMap.forEach((key, value) {
      if (value) {
        if (!firstSet) {
          firstSet = true;
        } else {
          fileName += '-';
        }
        fileName += key;
      }
    });
    return fileName;
  }
}
