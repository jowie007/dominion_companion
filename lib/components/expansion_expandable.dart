import 'package:dominion_companion/components/card_info_tile.dart';
import 'package:dominion_companion/components/round_checkbox.dart';
import 'package:dominion_companion/components/round_tooltip.dart';
import 'package:dominion_companion/components/select_version_dialog.dart';
import 'package:dominion_companion/model/expansion/expansion_model.dart';
import 'package:dominion_companion/services/active_expansion_version_service.dart';
import 'package:dominion_companion/services/audio_service.dart';
import 'package:dominion_companion/services/expansion_service.dart';
import 'package:dominion_companion/services/selected_card_service.dart';
import 'package:flutter/material.dart';

class ExpansionExpandable extends StatefulWidget {
  const ExpansionExpandable(
      {super.key,
      required this.expansion,
      required this.onChanged,
      required this.onReload,
      required this.resetSelectionNotifier});

  final ExpansionModel expansion;
  final void Function() onChanged;
  final VoidCallback onReload;
  final ValueNotifier<int> resetSelectionNotifier;

  @override
  State<ExpansionExpandable> createState() => _ExpansionExpandableState();
}

class _ExpansionExpandableState extends State<ExpansionExpandable>
    with AutomaticKeepAliveClientMixin<ExpansionExpandable> {
  SelectedCardService selectedCardService = SelectedCardService();
  bool anotherVersionOfExpansionHasSelectedCards = false;

  @override
  bool get wantKeepAlive => true;

  @override
  initState() {
    super.initState();
    widget.resetSelectionNotifier.addListener(_resetSelection);
    checkIfAnotherVersionOfExpansionHasSelectedCards();
  }

  @override
  void dispose() {
    // Remove the listener when the widget is disposed
    widget.resetSelectionNotifier.removeListener(_resetSelection);
    super.dispose();
  }

  void checkIfAnotherVersionOfExpansionHasSelectedCards() {
    selectedCardService
        .hasOtherVersionOfExpansionSelectedCards(widget.expansion)
        .then((value) {
      setState(() {
        anotherVersionOfExpansionHasSelectedCards = value;
      });
    });
  }

  void _resetSelection() {
    setState(() {
      anotherVersionOfExpansionHasSelectedCards = false;
    });
  }

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
                    title: GestureDetector(
                      onLongPress: () => showDialog<String>(
                        context: context,
                        useRootNavigator: false,
                        builder: (innerContext) =>
                            FutureBuilder<Map<String, String>>(
                          future: expansionService
                              .getAllExpansionNamesAndIdsStartingWithId(
                                  widget.expansion.id),
                          builder: (BuildContext context,
                              AsyncSnapshot<Map<String, String>> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Center(child: CircularProgressIndicator()),
                                ],
                              );
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              return SelectVersionDialog(
                                currentVersion: widget.expansion.id,
                                availableVersions: snapshot.data!,
                                onSaved: (selectedVersion) => setState(
                                  () {
                                    widget.onChanged();
                                    ActiveExpansionVersionService()
                                        .setActiveExpansionVersion(
                                            selectedVersion);
                                    widget.onReload();
                                  },
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      child: Container(
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
        anotherVersionOfExpansionHasSelectedCards
            ? const Positioned(
                right: 4.0,
                top: 12.0,
                child: RoundTooltip(
                  title:
                      "Eine andere Version\ndieser Erweiterung\nbesitzt ausgewählte\nKarten",
                  icon: Icons.info,
                ),
              )
            : Container(),
      ],
    );
  }
}
