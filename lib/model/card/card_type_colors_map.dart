import 'package:dominion_comanion/model/card/card_type_enum.dart';
import 'package:flutter/material.dart';

final Map<String, List<Color>> cardTypeColorsMap = {
  "aktion": [Colors.white],
  "aktion-angriff": [Colors.white],
  "aktion-reaktion": [Colors.blueAccent],
  "punkte": [Colors.green],
  "geld": [Colors.orangeAccent],
  "fluch": [Colors.deepPurple],
};