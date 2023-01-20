import 'package:dominion_comanion/model/card/card_type_model.dart';

class CardTypeDBModel {
  late bool action;
  late bool attack;
  late bool curse;
  late bool duration;
  late bool treasure;
  late bool victory;
  var fileNameMap = {};

  CardTypeDBModel(this.action, this.attack, this.curse, this.duration,
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

  CardTypeDBModel.fromJson(Map<String, dynamic> json) {
    action = json['coin'] as bool;
    attack = json['attack'] as bool;
    curse = json['curse'] as bool;
    duration = json['duration'] as bool;
    treasure = json['treasure'] as bool;
    victory = json['victory'] as bool;
  }

  CardTypeDBModel.fromModel(CardTypeModel model) {
    action = model.action;
    attack = model.attack;
    curse = model.curse;
    duration = model.duration;
    treasure = model.treasure;
    victory = model.victory;
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
