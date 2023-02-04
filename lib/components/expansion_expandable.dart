import 'package:dominion_comanion/components/card_info_tile.dart';
import 'package:dominion_comanion/components/round_checkbox.dart';
import 'package:dominion_comanion/model/expansion/expansion_model.dart';
import 'package:dominion_comanion/services/selected_card_service.dart';
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
    final selectedCardService = SelectedCardService();
    final expansionCardIds = widget.expansion.cards
        .where((card) => !card.invisible)
        .map((card) => card.id)
        .toList();
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: Stack(
              children: [
                SizedBox(
                  width: 400,
                  height: 56,
                  child: Image.asset(
                    "assets/artwork/boxart/${widget.expansion.id}.jpg",
                    fit: BoxFit.cover,
                  ),
                ),
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
                              [widget.expansion.name, widget.expansion.version]
                                  .join(" - "),
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
                          itemCount: widget.expansion.cards.length,
                          itemBuilder: (BuildContext context, int index) {
                            return !widget.expansion.cards[index].invisible
                                ? CardInfoTile(
                                    onChanged: (bool? newValue) => setState(() {
                                      selectedCardService
                                          .toggleSelectedCardIdDB(
                                              widget.expansion.cards[index].id);
                                      widget.onChanged();
                                    }),
                                    card: widget.expansion.cards[index],
                                    value: selectedCardService.selectedCardIds
                                        .contains(
                                            widget.expansion.cards[index].id),
                                  )
                                : Container();
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
                        .toggleSelectedExpansion(expansionCardIds);
                    widget.onChanged();
                  }),
              value: selectedCardService.isExpansionSelected(expansionCardIds)),
        ),
      ],
    );
  }
}
