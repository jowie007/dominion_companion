import 'dart:convert';

import 'package:dominion_comanion/model/expansion/expansion_model.dart';
import 'package:flutter/services.dart';

class JsonService {
  List<String> files = ['basisspiel_v2', 'bluetezeit_v2', 'alchemisten_v1', 'reiche_ernte_v1'];

  List<Future<ExpansionModel>> getExpansions() {
    return files
        .map((fileName) async => ExpansionModel.fromJson(jsonDecode(
            await rootBundle.loadString('assets/cards/json/$fileName.json'))))
        .toList();
  }
}
