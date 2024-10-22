import 'package:dominion_companion/components/select_another_card_dialog.dart';
import 'package:dominion_companion/model/card/card_model.dart';
import 'package:dominion_companion/model/deck/deck_model.dart';
import 'package:dominion_companion/services/card_service.dart';
import 'package:dominion_companion/services/content_service.dart';
import 'package:dominion_companion/services/player_service.dart';
import 'package:dominion_companion/services/temporary_deck_service.dart';
import 'package:flutter/material.dart';

class DeckAdditionalInfoTile extends StatefulWidget {
  const DeckAdditionalInfoTile(
      {super.key,
      required this.deckModel,
      required this.cards,
      this.onAddCard,
      this.isTemporary = false});

  final DeckModel deckModel;
  final List<CardModel> cards;
  final bool isTemporary;
  final void Function(Future<bool> isAdded)? onAddCard;

  @override
  State<DeckAdditionalInfoTile> createState() => _DeckAdditionalInfoTileState();
}

class _DeckAdditionalInfoTileState extends State<DeckAdditionalInfoTile> {
  final PlayerService _playerService = PlayerService();
  final CardService _cardService = CardService();
  final ContentService _contentService = ContentService();
  final TemporaryDeckService _temporaryDeckService = TemporaryDeckService();

  String prettyDateString(DateTime date) {
    return "${date.day < 10 ? 0 : ""}${date.day}.${date.month < 10 ? 0 : ""}${date.month}.${date.year} "
        "${date.hour < 10 ? 0 : ""}${date.hour}:${date.minute < 10 ? 0 : ""}${date.minute} Uhr";
  }

  void onAddCard() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return SelectAnotherCardDialog(onSaved: (String selectedCard) {
          Future<bool> isAdded =
              _temporaryDeckService.addCardToTemporaryDeck(selectedCard);
          if (widget.onAddCard != null) {
            widget.onAddCard!(isAdded);
          }
        });
      },
    );
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
              mainAxisAlignment: MainAxisAlignment.center, // Add this line
              children: [
                widget.deckModel.name == ""
                    ? Container(
                        margin: const EdgeInsets.fromLTRB(8, 0, 0, 8),
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: onAddCard,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                          ),
                          child: const Icon(Icons.add_circle_outline_rounded),
                        ),
                      )
                    : Container(),
                widget.deckModel.content.isNotEmpty
                    ? Column(
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.stars, size: 14),
                              SizedBox(width: 8),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Text(content
                                        .count[_playerService.players - 1]),
                                    const Text("x "),
                                    Expanded(child: Text(content.name)),
                                  ],
                                ),
                            ],
                          ),
                        ],
                      )
                    : Container(),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                  return Expanded(
                                      child: Text(snapshot.data != null
                                          ? snapshot.data!
                                          : ''));
                                },
                              ),
                            ],
                          ),
                        for (var card
                            in widget.deckModel.handOtherCards.getAllElements())
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                  return Expanded(
                                      child: Text(snapshot.data != null
                                          ? snapshot.data!
                                          : ''));
                                },
                              ),
                            ],
                          ),
                        for (var content
                            in widget.deckModel.handContents.getAllElements())
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                  return Expanded(
                                      child: Text(snapshot.data != null
                                          ? snapshot.data!.name
                                          : 'Fehler'));
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
                !widget.isTemporary
                    ? const Row(
                        children: [
                          Icon(Icons.info_outline, size: 14),
                          SizedBox(width: 8),
                          Text(
                            "Voller Name:",
                            style:
                                TextStyle(decoration: TextDecoration.underline),
                          ),
                        ],
                      )
                    : Container(),
                !widget.isTemporary
                    ? Row(
                        children: [
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(child: Text(widget.deckModel.name)),
                        ],
                      )
                    : Container(),
                !widget.isTemporary && widget.deckModel.description != ''
                    ? const Row(
                        children: [
                          Icon(Icons.description, size: 14),
                          SizedBox(width: 8),
                          Text(
                            "Beschreibung:",
                            style:
                                TextStyle(decoration: TextDecoration.underline),
                          ),
                        ],
                      )
                    : Container(),
                !widget.isTemporary && widget.deckModel.description != ''
                    ? Row(
                        children: [
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(child: Text(widget.deckModel.description)),
                        ],
                      )
                    : Container(),
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
