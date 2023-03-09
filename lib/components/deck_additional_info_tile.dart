import 'dart:developer';

import 'package:dominion_comanion/model/deck/deck_model.dart';
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
    log(widget.deckModel.end.emptyCards.toString());

    return Container(
      color: Colors.white.withOpacity(0.8),
      child: ListTile(
        title: Column(
          children: [
            widget.deckModel.content != null
                ? Column(
                    children: [
                      Row(
                        children: const [
                          Text(
                            "Extras:",
                            style:
                                TextStyle(decoration: TextDecoration.underline),
                          ),
                        ],
                      ),
                      Text(widget.deckModel.content!.count.toString())
                    ],
                  )
                : Container(),
            widget.deckModel.hand.cardIdCountMap != null
                ? Column(
                    children: [
                      Row(
                        children: const [
                          Text(
                            "Austeilen:",
                            style:
                                TextStyle(decoration: TextDecoration.underline),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          for (var card
                              in widget.deckModel.hand.cardIdCountMap!.entries)
                            Row(
                              children: [
                                const SizedBox(
                                  width: 20,
                                ),
                                Text(card.value.toString()),
                                const Text("x "),
                                Text(card.key),
                              ],
                            ),
                        ],
                      ),
                    ],
                  )
                : Container(),
            Row(
              children: const [
                Text(
                  "Ende:",
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              ],
            ),
            Row(
              children: [
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Text(
                      "Wenn ${widget.deckModel.end.emptyCount} Stapel leer sind oder wenn einer der "
                      "folgenden Stapel leer ist: "
                      "${widget.deckModel.end.emptyCards.join(", ")}"
                      "${widget.deckModel.end.additionalEmptyCards.join(", ")}"),
                ),
              ],
            ),
          ],
        ),
      ), // subtitle: const Text('This is tile number 2'),
    );
  }
}
