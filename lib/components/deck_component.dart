import 'package:dominion_comanion/model/deck/deck_model.dart';
import 'package:flutter/material.dart';

class DeckComponent extends StatelessWidget {
  const DeckComponent({Key? key, required this.deck}) : super(key: key);

  final Deck deck;

  @override
  Widget build(BuildContext context) {
    return Text(deck.name,
        textAlign: TextAlign.center,
        style: const TextStyle(
            fontFamily: 'TrajanPro', fontSize: 24, color: Colors.black));
  }
}
