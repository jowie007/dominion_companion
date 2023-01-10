import 'dart:convert';

import 'package:dominion_comanion/model/card/card_model.dart';

class Deck {
  final int id;
  final String name;
  final List<int> cardIds;

  const Deck({required this.id, required this.name, required this.cardIds});

  Map<String, dynamic> toJson() =>
      {'id': id, 'name': name, 'cardIds': jsonEncode(cardIds)};
}
