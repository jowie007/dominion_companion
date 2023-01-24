import 'dart:convert';

import 'package:dominion_comanion/model/expansion/expansion_model.dart';
import 'package:flutter/services.dart';

class JsonService {
  List<String> files = ['base_v2', 'base_v3'];

  List<Future<ExpansionModel>> getExpansions() {
    return files
        .map((fileName) async => ExpansionModel.fromJson(jsonDecode(
            await rootBundle.loadString('assets/cards/json/$fileName.json'))))
        .toList();
  }
}
