import 'package:dominion_companion/components/card_info_tile.dart';
import 'package:dominion_companion/components/custom_alert_dialog.dart';
import 'package:dominion_companion/components/deck_additional_info_tile.dart';
import 'package:dominion_companion/components/dropdown_rating.dart';
import 'package:dominion_companion/components/name_deck_dialog.dart';
import 'package:dominion_companion/model/deck/deck_model.dart';
import 'package:dominion_companion/services/audio_service.dart';
import 'package:dominion_companion/services/deck_service.dart';
import 'package:dominion_companion/services/temporary_deck_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:dominion_companion/router/routes.dart' as route;

class DeckExpandable extends StatefulWidget {
  const DeckExpandable(
      {super.key,
      required this.deckModel,
      this.initiallyExpanded = false,
      this.isNewlyCreated = false,
      this.onChange,
      this.onRouteLeave,
      this.onCardReplace,
      this.onCardAdd});

  final DeckModel deckModel;
  final bool initiallyExpanded;
  final bool isNewlyCreated;
  final void Function()? onChange;
  final void Function()? onRouteLeave;
  final void Function(Future<bool> isCardReplaced)? onCardReplace;
  final void Function(Future<bool> isCardAdded)? onCardAdd;

  @override
  State<DeckExpandable> createState() => _DeckExpandableState();
}

class _DeckExpandableState extends State<DeckExpandable> {
  DeckService deckService = DeckService();
  TemporaryDeckService temporaryDeckService = TemporaryDeckService();
  bool isExpanded = false;

  Color pickerColor = Colors.white;

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  Future pickColor() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: AlertDialog(
            content: Padding(
              padding: const EdgeInsets.all(0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(
                    height: 10,
                  ),
                  const Text('Farbe auswählen'),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: SingleChildScrollView(
                      child: BlockPicker(
                        pickerColor: pickerColor,
                        onColorChanged: changeColor,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Abbrechen'),
                      ),
                      TextButton(
                        onPressed: () {
                          deckService.saveNewColor(
                              widget.deckModel.id, pickerColor);
                          Navigator.pop(context);
                        },
                        child: const Text('Speichern'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // https://stackoverflow.com/questions/53908025/flutter-sortable-drag-and-drop-listview
  @override
  Widget build(BuildContext context) {
    final allCards = widget.deckModel.getAllCards();
    void onChange() {
      if (widget.onChange != null) {
        widget.onChange!();
      }
    }

    final audioService = AudioService();

    const backgroundImage = AssetImage("assets/menu/main_scroll_crop.png");
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(0.0),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: Dismissible(
              key: widget.key ?? Key(widget.deckModel.name),
              direction: !widget.isNewlyCreated && !isExpanded
                  ? DismissDirection.horizontal
                  : DismissDirection.none,
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 20),
                // change this to your desired color or widget
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              secondaryBackground: Container(
                color: Colors.black,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                // change this to your desired color or widget
                child: const Icon(Icons.edit, color: Colors.white),
              ),
              confirmDismiss: (direction) async {
                if (direction == DismissDirection.startToEnd) {
                  final delete = await showDialog(
                        context: context,
                        builder: (context) {
                          return const CustomAlertDialog(
                            title: "Löschen",
                            message: "Soll das Deck wirklich gelöscht werden?",
                          );
                        },
                      ) ??
                      false;
                  if (delete == true) {
                    setState(() {
                      DeckService().deleteDeckById(widget.deckModel.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Deck wurde gelöscht")));
                    });
                    onChange();
                  }
                  return delete;
                }
                if (direction == DismissDirection.endToStart) {
                  return await showDialog(
                        context: context,
                        builder: (context) {
                          return const CustomAlertDialog(
                            title: "Bearbeiten",
                            message:
                                "Sollen die enthaltenen Karten angepasst werden?",
                          );
                        },
                      ) ??
                      false;
                }
                return false;
              },
              onDismissed: (direction) async {
                if (direction == DismissDirection.endToStart) {
                  if (widget.onRouteLeave != null) {
                    widget.onRouteLeave!();
                  }
                  Navigator.pushNamed(context, route.createDeckPage,
                          arguments: {"deckId": widget.deckModel.id})
                      .then((value) => onChange());
                }
              },
              child: Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 56,
                    decoration: BoxDecoration(
                        color: widget.deckModel.getColorAsColor()),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Theme(
                      data: Theme.of(context)
                          .copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        onExpansionChanged: (value) => {
                          setState(() {
                            isExpanded = value;
                          }),
                          if (value)
                            {audioService.playAudioOpen()}
                          else
                            {audioService.playAudioClose()}
                        },
                        initiallyExpanded: widget.initiallyExpanded,
                        trailing: const SizedBox(
                          width: 0,
                          height: 0,
                        ),
                        collapsedIconColor: Colors.white,
                        title: GestureDetector(
                          onLongPress: () => !widget.isNewlyCreated
                              ? showDialog<String>(
                                  context: context,
                                  useRootNavigator: false,
                                  builder: (innerContext) => NameDeckDialog(
                                    oldName: widget.deckModel.name,
                                    oldDescription:
                                        widget.deckModel.description,
                                    onSaved: (deckName, deckDescription) =>
                                        setState(
                                      () {
                                        DeckService()
                                            .changeDeckNameAndDescription(
                                                widget.deckModel.id!,
                                                deckName,
                                                deckDescription)
                                            .then((value) => onChange());
                                      },
                                    ),
                                  ),
                                )
                              : null,
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(60, 0, 20, 0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: Container(
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: backgroundImage,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(4, 2, 4, 0),
                                  child: Text(
                                    widget.deckModel.name != ""
                                        ? widget.deckModel.name
                                        : "Temporäres Deck",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
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
                              physics: const ClampingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: allCards.length + 1,
                              itemBuilder: (BuildContext context, int index) {
                                return index < allCards.length
                                    ? CardInfoTile(
                                        onChanged: (bool? newValue) =>
                                            (newValue),
                                        dismissible:
                                            widget.deckModel.name == "",
                                        onSwapDelete: () {
                                          setState(() {
                                            if (widget.onCardReplace != null) {
                                              widget.onCardReplace!(
                                                  temporaryDeckService
                                                      .removeCardFromTemporaryDeck(
                                                          allCards[index].id));
                                            }
                                          });
                                        },
                                        onSwapRandom: () {
                                          setState(() {
                                            if (widget.onCardReplace != null) {
                                              widget.onCardReplace!(
                                                  temporaryDeckService
                                                      .replaceCardFromTemporaryDeckRandom(
                                                          allCards[index].id));
                                            }
                                          });
                                        },
                                        card: allCards[index],
                                        value: true,
                                        hasCheckbox: false,
                                        showCardCount: true,
                                      )
                                    : DeckAdditionalInfoTile(
                                        deckModel: widget.deckModel,
                                        cards: allCards,
                                        isTemporary: widget.isNewlyCreated,
                                        onAddCard: (isAdded) => {
                                          setState(() {
                                            if (widget.onCardAdd != null) {
                                              widget.onCardAdd!(isAdded);
                                            }
                                          })
                                        },
                                      );
                              })
                        ],
                      ),
                    ),
                  ),
                  !widget.isNewlyCreated
                      ? Container(
                          height: 56,
                          padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                          child: Align(
                            alignment: FractionalOffset.centerLeft,
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2000),
                                image: const DecorationImage(
                                  image: backgroundImage,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: FittedBox(
                                fit: BoxFit.cover,
                                alignment: Alignment.center,
                                child: GestureDetector(
                                  onLongPress: () {
                                    showDialog<bool>(
                                      context: context,
                                      builder: (context) {
                                        return CustomAlertDialog(
                                          title: "Farbe entfernen",
                                          message:
                                              "Soll die aktuelle Farbe entfernt werden?",
                                          onConfirm: () => setState(() {
                                            widget.deckModel.color =
                                                Colors.white.toString();
                                          }),
                                        );
                                      },
                                    );
                                  },
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.color_lens,
                                      color: Colors.black,
                                    ),
                                    onPressed: () =>
                                        {pickColor().then((_) => onChange())},
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      : Container(),
                  !widget.isNewlyCreated
                      ? Container(
                          height: 56,
                          padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
                          child: Align(
                            alignment: FractionalOffset.centerRight,
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2000),
                                image: const DecorationImage(
                                  image: backgroundImage,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: FittedBox(
                                fit: BoxFit.contain,
                                alignment: Alignment.center,
                                child: DropdownSort(
                                  width: 30,
                                  rating: widget.deckModel.rating,
                                  onChanged: (value) => {
                                    widget.deckModel.rating =
                                        value == null ? null : int.parse(value),
                                    deckService
                                        .updateDeck(widget.deckModel)
                                        .then((_) => onChange())
                                  },
                                ),
                              ),
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
