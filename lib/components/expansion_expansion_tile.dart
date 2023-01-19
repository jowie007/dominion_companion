import 'package:dominion_comanion/components/card_info_tile.dart';
import 'package:dominion_comanion/model/card/card_model.dart';
import 'package:flutter/material.dart';

class ExpansionExpansionTile extends StatelessWidget {
  const ExpansionExpansionTile(
      {super.key,
      required this.onChanged,
      required this.title,
      required this.cards});

  final void Function(bool? value) onChanged;
  final String title;
  final List<CardModel> cards;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'TrajanPro',
            fontSize: 24,
            shadows: <Shadow>[
              Shadow(
                offset: Offset(0.0, 0.0),
                blurRadius: 1.0,
                color: Colors.black,
              ),
              Shadow(
                offset: Offset(1.0, 1.0),
                blurRadius: 1.0,
                color: Colors.black,
              ),
              Shadow(
                offset: Offset(1.0, 1.0),
                blurRadius: 2.0,
                color: Colors.black,
              ),
            ],
          )),
      children: <Widget>[
        ListView.builder(
            // padding: const EdgeInsets.all(8),
            shrinkWrap: true,
            itemCount: cards.length,
            itemBuilder: (BuildContext context, int index) {
              return CardInfoTile(
                onChanged: onChanged,
                card: cards[index],
              );
            })
      ],
    );
  }
}
