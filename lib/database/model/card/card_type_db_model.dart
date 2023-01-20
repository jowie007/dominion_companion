import 'dart:collection';

class CardTypeDBModel {
  final bool action;
  final bool attack;
  final bool curse;
  final bool duration;
  final bool treasure;
  final bool victory;
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
