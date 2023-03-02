import 'package:dominion_comanion/components/coin_component.dart';
import 'package:dominion_comanion/components/round_checkbox.dart';
import 'package:dominion_comanion/components/expansion_icon.dart';
import 'package:dominion_comanion/model/card/card_model.dart';
import 'package:dominion_comanion/model/deck/deck_model.dart';
import 'package:dominion_comanion/services/card_service.dart';
import 'package:dominion_comanion/services/player_service.dart';
import 'package:flutter/material.dart';

class DeckAdditionalInfoTile extends StatefulWidget {
  const DeckAdditionalInfoTile({super.key, required this.deckModel});

  final DeckModel deckModel;

  @override
  State<DeckAdditionalInfoTile> createState() => _DeckAdditionalInfoTileState();
}

class _DeckAdditionalInfoTileState extends State<DeckAdditionalInfoTile> {
  @override
  Widget build(BuildContext context) {
    final PlayerService playerService = PlayerService();
    final allEmptyCards = widget.deckModel.end.emptyCards;

    return Container(
      color: Colors.white.withOpacity(0.8),
      child: ListTile(
        title: Column(
          children: [
            const Text("Extras:"),
            widget.deckModel.content != null
                ? Text(widget.deckModel.content!.count.toString())
                : Container(),
            const Text("Austeilen:"),
            widget.deckModel.hand.cardIdCountMap != null
                ? Column(children: [
                    for (var card
                        in widget.deckModel.hand.cardIdCountMap!.entries)
                      Row(children: [
                        Text(card.key),
                        Text(card.value.toString())
                      ])
                  ])
                : Container(),
            const Text("Ende:"),
            Text(
                "Wenn ${widget.deckModel.end.emptyCards} Stapel leer sind oder wenn einer der "
                "${widget.deckModel.end.emptyCards}folgenden Stapel leer ist: "
                "${widget.deckModel.end.emptyCards.join(", ")}"
                "${widget.deckModel.end.additionalEmptyCards.join(", ")}"),
          ],
        ),
      ),
      // subtitle: const Text('This is tile number 2'),
    );
  }
}
