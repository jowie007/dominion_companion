import 'dart:developer';

import 'package:dominion_comanion/components/card_info_tile.dart';
import 'package:dominion_comanion/components/round_checkbox.dart';
import 'package:dominion_comanion/model/card/card_model.dart';
import 'package:dominion_comanion/model/deck/deck_model.dart';
import 'package:dominion_comanion/services/selected_card_service.dart';
import 'package:flutter/material.dart';

class DeckExpandable extends StatefulWidget {
  const DeckExpandable(
      {super.key,
        required this.deckModel});

  final DeckModel deckModel;

  @override
  State<DeckExpandable> createState() => _DeckExpandableState();
}

class _DeckExpandableState extends State<DeckExpandable> {
  // https://stackoverflow.com/questions/53908025/flutter-sortable-drag-and-drop-listview
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: Stack(
              children: [
                /*SizedBox(
                  width: 400,
                  height: 56,
                  child: Image.asset(
                    "assets/artwork/boxart/${widget.imagePath}.jpg",
                    fit: BoxFit.cover,
                  ),
                ),*/
                Container(
                  alignment: Alignment.center,
                  child: ExpansionTile(
                    trailing: const SizedBox(
                      width: 0,
                      height: 0,
                    ),
                    collapsedIconColor: Colors.white,
                    title: Container(
                      padding: const EdgeInsets.fromLTRB(60, 0, 20, 0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: Container(
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                  "assets/menu/main_scroll_crop.png"),
                              fit: BoxFit.cover,
                            ),
                          ),
                          padding: const EdgeInsets.fromLTRB(0, 2, 0, 2),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.center,
                            child: Text(
                              widget.deckModel.name,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    children: <Widget>[
                      ListView.builder(
                        // padding: const EdgeInsets.all(8),
                          physics: const ClampingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: widget.deckModel.cards.length,
                          itemBuilder: (BuildContext context, int index) {
                            return CardInfoTile(
                              onChanged: (bool? newValue) => (newValue),
                              card: widget.deckModel.cards[index],
                              value: true,
                            );
                          })
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}