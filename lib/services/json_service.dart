import 'dart:convert';
import 'dart:developer';

import 'package:dominion_companion/model/expansion/expansion_model.dart';
import 'package:flutter/services.dart';

class JsonService {
  List<String> files = [
    'basisspiel_v1',
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
    'pluenderer_v1',
    'promos_v1',
    'ausgemustert_v1',
  ];

  Future<List<ExpansionModel>> getExpansionsFromJSON() async {
    try {
      List<Future<ExpansionModel>> futures = files.map((fileName) async {
        String jsonString = await rootBundle.loadString('assets/cards/json/$fileName.json');
        Map<String, dynamic> jsonMap = jsonDecode(jsonString);
        return ExpansionModel.fromJson(jsonMap);
      }).toList();
      return await Future.wait(futures);
    } catch (e) {
      log('Error loading expansions: $e');
      return [];
    }
  }

}
