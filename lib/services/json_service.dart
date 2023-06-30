import 'dart:convert';

import 'package:dominion_companion/model/expansion/expansion_model.dart';
import 'package:flutter/services.dart';

class JsonService {
  List<String> files = [
    'basisspiel_v2',
    'bluetezeit_v2',
    'alchemisten_v1',
    'reiche_ernte_v1',
    'intrige_v2',
    'seaside_v2',
    'hinterland_v2',
    'dark_ages_v1',
    'gilden_v1',
    'abenteuer_v1',
    'empires_v2',
    'nocturne_v1',
    'renaissance_v1',
    'menagerie_v1',
    'verbuendete_v1',
  ];

  List<Future<ExpansionModel>> getExpansionsFromJSON() {
    return files
        .map((fileName) async => ExpansionModel.fromJson(jsonDecode(
            await rootBundle.loadString('assets/cards/json/$fileName.json'))))
        .toList();
  }
}
