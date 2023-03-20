import 'dart:convert';
import 'dart:developer';

import 'package:dominion_comanion/model/card/card_model.dart';
import 'package:dominion_comanion/model/deck/deck_model.dart';
import 'package:dominion_comanion/services/card_service.dart';
import 'package:dominion_comanion/services/content_service.dart';
import 'package:dominion_comanion/services/player_service.dart';
import 'package:flutter/material.dart';

class DeckAdditionalInfoTile extends StatefulWidget {
  const DeckAdditionalInfoTile(
      {super.key, required this.deckModel, required this.cards});

  final DeckModel deckModel;
  final List<CardModel> cards;

  @override
  State<DeckAdditionalInfoTile> createState() => _DeckAdditionalInfoTileState();
}

class _DeckAdditionalInfoTileState extends State<DeckAdditionalInfoTile> {
  final PlayerService _playerService = PlayerService();
  final CardService _cardService = CardService();
  final ContentService _contentService = ContentService();

  @override
  Widget build(BuildContext context) {
    final allEmptyCards = widget.deckModel.end.getAllEmptyCardIds();
    return ValueListenableBuilder(
      valueListenable: _playerService.notifier,
      builder: (BuildContext context, bool val, Widget? child) {
        return Container(
          color: Colors.white.withOpacity(0.8),
          child: ListTile(
            title: Column(
              children: [
                widget.deckModel.content.isNotEmpty
                    ? Column(
                        children: [
                          Row(
                            children: const [
                              Text(
                                "Extras:",
                                style: TextStyle(
                                    decoration: TextDecoration.underline),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              for (var content in widget.deckModel.content)
                                Row(
                                  children: [
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Text(content
                                        .count[_playerService.players - 1]),
                                    const Text("x "),
                                    Text(content.name),
                                  ],
                                ),
                            ],
                          ),
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
                                style: TextStyle(
                                    decoration: TextDecoration.underline),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              for (var card
                                  in widget.deckModel.hand.getAllCards())
                                Row(
                                  children: [
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Text(card.value.toString()),
                                    const Text("x "),
                                    FutureBuilder(
                                      future: _cardService.filterCardName(
                                          widget.cards, card.key),
                                      builder: (context, snapshot) {
                                        return Text(snapshot.data != null
                                            ? snapshot.data!
                                            : '');
                                      },
                                    ),
                                  ],
                                ),
                               for (var content
                                  in widget.deckModel.hand.getAllContents())
                                Row(
                                  children: [
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Text(content.value.toString()),
                                    const Text("x "),
                                    FutureBuilder(
                                      future: _contentService
                                          .getContentById(content.key.toString()),
                                      builder: (context, snapshot) {
                                        return Text(snapshot.data != null
                                            ? snapshot.data!.name
                                            : 'Test');
                                      },
                                    ),
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
                      child: FutureBuilder(
                        future: Future.wait(allEmptyCards.map((cardId) =>
                            _cardService.filterCardName(widget.cards, cardId))),
                        builder: (context, snapshot) {
                          return Text(
                              "Wenn ${widget.deckModel.end.emptyCount} Stapel leer sind ${snapshot.data != null ? "oder wenn "
                                  "${allEmptyCards.length > 1 ? 'einer' : ''} der "
                                  "folgende${allEmptyCards.length > 1 ? 'n' : ''} Stapel leer ist: "
                                  "${snapshot.data!.join(", ")}" : ''}");
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
