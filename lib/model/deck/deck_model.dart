import 'package:flutter/material.dart';

class DeckModel {
  final String id;
  final String name;
  final List<Card> cards;

  const DeckModel({required this.id, required this.name, required this.cards});

  factory DeckModel.fromDatabase(String id, String name, List<Card> cards) =>
      DeckModel(id: id, name: name, cards: cards);
}
