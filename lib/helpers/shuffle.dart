import 'dart:collection';
import 'dart:math';

class Shuffle {
  static Map<dynamic, dynamic> shuffleMap(Map<dynamic, dynamic> map) {
    var retMap = HashMap();
    var keys = map.keys.toList();
    keys.shuffle(Random());
    for (var key in keys) {
      retMap[key] = map[key];
    }
    return retMap;
  }
}
