import 'package:dominion_comanion/components/card_info_tile.dart';
import 'package:dominion_comanion/components/round_checkbox.dart';
import 'package:dominion_comanion/model/card/card_model.dart';
import 'package:dominion_comanion/services/selected_card_service.dart';
import 'package:flutter/material.dart';

class ExpansionExpandable extends StatefulWidget {
  const ExpansionExpandable(
      {super.key,
      required this.imagePath,
      required this.title,
      required this.cards,
      required this.selectedCardService});

  final String imagePath;
  final String title;
  final List<CardModel> cards;
  final SelectedCardService selectedCardService;

  @override
  State<ExpansionExpandable> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<ExpansionExpandable> {
  dynamic _allSelected = false;

  void _onCheckboxChanged(bool? newValue) => setState(() {
        if (_allSelected == null) {
          _allSelected = false;
        } else {
          _allSelected = !_allSelected;
        }
      });

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
                SizedBox(
                  width: 400,
                  height: 56,
                  child: Image.asset(
                    "assets/artwork/boxart/${widget.imagePath}.jpg",
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
                              widget.title,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: 'TrajanPro',
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
                          itemCount: widget.cards.length,
                          itemBuilder: (BuildContext context, int index) {
                            return !widget.cards[index].invisible
                                ? CardInfoTile(
                                    onChanged: (bool? newValue) => widget
                                        .selectedCardService
                                        .toggleSelectedCardIdDB(
                                            widget.cards[index].id),
                                    card: widget.cards[index],
                                    value: widget
                                        .selectedCardService.selectedCardIds
                                        .contains(widget.cards[index].id),
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
            onChanged: _onCheckboxChanged,
            value: _allSelected,
          ),
        ),
      ],
    );
  }
}
