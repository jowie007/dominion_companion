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

  String prettyDateString(DateTime date) {
    return "${date.day < 10 ? 0 : ""}${date.day}.${date.month < 10 ? 0 : ""}${date.month}.${date.year} "
        "${date.hour < 10 ? 0 : ""}${date.hour}:${date.minute < 10 ? 0 : ""}${date.minute} Uhr";
  }

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
                          const Row(
                            children: [
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
                const Row(
                  children: [
                    Icon(Icons.info_outline, size: 14),
                    SizedBox(width: 8),
                    Text(
                      "Voller Name:",
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
                            widget.deckModel.name)),
                  ],
                ),
                Column(
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.collections_bookmark, size: 14),
                        SizedBox(width: 8),
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
                            in widget.deckModel.handMoneyCards.getAllElements())
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
                        for (var card
                            in widget.deckModel.handOtherCards.getAllElements())
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
                            in widget.deckModel.handContents.getAllElements())
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
                ),
                const Row(
                  children: [
                    Icon(Icons.av_timer_rounded, size: 14),
                    SizedBox(width: 8),
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
                const Row(
                  children: [
                    Icon(Icons.cake_outlined, size: 14),
                    SizedBox(width: 8),
                    Text(
                      "Erstelldatum:",
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
                            prettyDateString(widget.deckModel.creationDate))),
                  ],
                ),
                widget.deckModel.editDate != null
                    ? const Row(
                        children: [
                          Icon(Icons.refresh, size: 14),
                          SizedBox(width: 8),
                          Text(
                            "Bearbeitungsdatum:",
                            style:
                                TextStyle(decoration: TextDecoration.underline),
                          ),
                        ],
                      )
                    : Container(),
                widget.deckModel.editDate != null
                    ? Row(
                        children: [
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                              child: Text(prettyDateString(
                                  widget.deckModel.editDate!))),
                        ],
                      )
                    : Container(),
              ],
            ),
          ),
        );
      },
    );
  }
}
