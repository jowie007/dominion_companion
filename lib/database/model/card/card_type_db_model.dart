import 'package:dominion_comanion/model/card/card_type_model.dart';

class CardTypeDBModel {
  late bool action;
  late bool attack;
  late bool curse;
  late bool duration;
  late bool treasure;
  late bool victory;
  var fileNameMap = {};

  CardTypeDBModel(this.action, this.attack, this.curse, this.duration, this.treasure,
      this.victory) {
    fileNameMap.addAll({
      'action': action,
      'attack': attack,
      'curse': curse,
      'duration': duration,
      'treasure': treasure,
      'victory': victory
    });
  }

  CardTypeDBModel.fromModel(CardTypeModel model) {
    action = model.action;
    attack = model.attack;
    curse = model.curse;
    duration = model.duration;
    treasure = model.treasure;
    victory = model.victory;
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

  Map<String, dynamic> toJson() => {
        'action': action,
        'attack': attack,
        'curse': curse,
        'duration': duration,
        'treasure': treasure,
        'victory': victory,
      };
}
