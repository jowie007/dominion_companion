import 'dart:convert';
import 'dart:developer';

import 'package:dominion_comanion/model/card/card_type_enum.dart';

class Converters {
  static Map<String, int> stringIntMapFromJSON(dynamic json) {
    Map<String, int> retMap = {};
    var jsonMap = Map<String, String>.from(json);
    for (var stringMapKey in jsonMap.keys) {
      retMap[stringMapKey] = int.parse(json[stringMapKey]);
    }
    return retMap;
  }

  static String? stringIntMapToDB(Map<String, int>? value) {
    Map<String, String> retMap = {};
    String? ret;
    if (value != null) {
      for (var valueKey in value.keys) {
        retMap['"$valueKey"'] = '"${value[valueKey]}"';
      }
      ret = retMap.toString();
    }
    return ret;
  }

  static String intStringListMapToDB(Map<int, List<String>> value) {
    Map<String, List<String>> retMap = {};
    for (var valueKey in value.keys) {
      retMap['"$valueKey"'] = value[valueKey]!.map((e) => '"$e"').toList();
    }
    var ret = retMap.toString();
    ret.replaceAll("=", "-");
    return ret;
  }

  static String stringStringListMapToDB(Map<String, List<String>> value) {
    Map<String, List<String>> retMap = {};
    for (var valueKey in value.keys) {
      retMap['"$valueKey"'] = value[valueKey]!.map((e) => '"$e"').toList();
    }
    var ret = retMap.toString();
    ret.replaceAll("=", "-");
    return ret;
  }

  static String intCardTypeEnumListListMapToDB(
      Map<int, List<List<CardTypeEnum>>> value) {
    Map<String, List<String>> retMap = {};
    for (var valueKey in value.keys) {
      retMap['"$valueKey"'] = value[valueKey]!
          .map((e) => '"${e.map((e) => e.name).join(", ")}"')
          .toList();
    }
    var ret = retMap.toString();
    ret.replaceAll("=", "-");
    return ret;
  }

  static Map<int, List<String>> intStringListMapFromJSON(dynamic json) {
    Map<int, List<String>> retMap = {};
    var jsonMap = Map<String, List<dynamic>>.from(json);
    for (var stringMapKey in jsonMap.keys) {
      retMap[int.parse(stringMapKey)] =
          List<String>.from(json[stringMapKey]).toList();
    }
    return retMap;
  }

  // TODO Plagen & Gaben unsichtbar machen ??? DONE?
  // TODO Horizontale Karten drehen && Symbol eckiger gestalten
  static Map<String, List<String>> stringStringListMapFromJSON(dynamic json) {
    Map<String, List<String>> retMap = {};
    var jsonMap = Map<String, List<dynamic>>.from(json);
    for (var stringMapKey in jsonMap.keys) {
      retMap[stringMapKey] = List<String>.from(json[stringMapKey]).toList();
    }
    return retMap;
  }
}