import 'package:dominion_companion/components/card_info_tile.dart';
import 'package:dominion_companion/components/round_checkbox.dart';
import 'package:dominion_companion/model/expansion/expansion_model.dart';
import 'package:dominion_companion/services/audio_service.dart';
import 'package:dominion_companion/services/expansion_service.dart';
import 'package:dominion_companion/services/selected_card_service.dart';
import 'package:flutter/material.dart';

class ExpansionExpandable extends StatefulWidget {
  const ExpansionExpandable(
      {super.key, required this.expansion, required this.onChanged});

  final ExpansionModel expansion;
  final void Function() onChanged;

  @override
  State<ExpansionExpandable> createState() => _ExpansionExpandableState();
}

class _ExpansionExpandableState extends State<ExpansionExpandable> {
  // https://stackoverflow.com/questions/53908025/flutter-sortable-drag-and-drop-listview
  @override
  Widget build(BuildContext context) {
    final expansionService = ExpansionService();
    final selectedCardService = SelectedCardService();
    final audioService = AudioService();
    final visibleCards = widget.expansion.getVisibleCards();
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: Stack(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 56,
                  child: Image.asset(
                    "assets/artwork/boxart/${widget.expansion.id}.jpg",
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: ExpansionTile(
                    onExpansionChanged: (value) => {
                      if (value)
                        {audioService.playAudioOpen()}
                      else
                        {audioService.playAudioClose()}
                    },
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
                              expansionService
                                  .getExpansionName(widget.expansion),
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
                          itemCount: visibleCards.length,
                          itemBuilder: (BuildContext context, int index) {
                            var card = visibleCards[index];
                            return CardInfoTile(
                              onChanged: (bool? newValue) => setState(() {
                                selectedCardService
                                    .toggleSelectedCardId(card.id);
                                widget.onChanged();
                              }),
                              card: card,
                              value: selectedCardService.selectedCardIds
                                  .contains(card.id),
                            );
                          })
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          left: 0.0,
          top: 0.0,
          child: RoundCheckbox(
              onChanged: (bool? newValue) => setState(() {
                    selectedCardService
                        .toggleSelectedExpansion(widget.expansion);
                    widget.onChanged();
                  }),
              value: selectedCardService.isExpansionSelected(widget.expansion)),
        ),
      ],
    );
  }
}
