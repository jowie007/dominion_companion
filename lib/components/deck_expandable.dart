import 'dart:developer';
import 'dart:io';

import 'package:dominion_comanion/components/card_info_tile.dart';
import 'package:dominion_comanion/components/custom_alert_dialog.dart';
import 'package:dominion_comanion/components/deck_additional_info_tile.dart';
import 'package:dominion_comanion/components/dropdown_rating.dart';
import 'package:dominion_comanion/components/error_dialog.dart';
import 'package:dominion_comanion/components/name_deck_dialog.dart';
import 'package:dominion_comanion/model/deck/deck_model.dart';
import 'package:dominion_comanion/services/deck_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dominion_comanion/router/routes.dart' as route;

class DeckExpandable extends StatefulWidget {
  const DeckExpandable(
      {super.key,
      required this.deckModel,
      this.initiallyExpanded = false,
      this.isNewlyCreated = false,
      this.onChange});

  final DeckModel deckModel;
  final bool initiallyExpanded;
  final bool isNewlyCreated;
  final void Function()? onChange;

  @override
  State<DeckExpandable> createState() => _DeckExpandableState();
}

class _DeckExpandableState extends State<DeckExpandable> {
  DeckService deckService = DeckService();

  // https://medium.com/unitechie/flutter-tutorial-image-picker-from-camera-gallery-c27af5490b74
  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      setState(() {
        widget.deckModel.image = File(image.path);
        deckService.updateDeck(widget.deckModel);
      });
    } on PlatformException catch (e) {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return const ErrorDialog(
                title: "Fehler", message: "Bild konnte nicht geöffnet werden");
          });
    }
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

    const backgroundImage = AssetImage("assets/menu/main_scroll_crop.png");
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: Dismissible(
          key: Key(widget.deckModel.name),
          background: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                  padding: EdgeInsets.fromLTRB(20, 16, 0, 0),
                  child: Icon(Icons.delete)),
            ],
          ),
          secondaryBackground: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                  padding: EdgeInsets.fromLTRB(0, 16, 20, 0),
                  child: Icon(Icons.swap_horizontal_circle)),
            ],
          ),
          direction: !widget.isNewlyCreated
              ? DismissDirection.horizontal
              : DismissDirection.none,
          confirmDismiss: (direction) async {
            if (direction == DismissDirection.startToEnd) {
              final delete = await showDialog<bool>(
                context: context,
                builder: (context) {
                  return const CustomAlertDialog(
                    title: "Löschen",
                    message: "Soll das Deck wirklich gelöscht werden?",
                  );
                },
              );
              if (delete == true) {
                setState(() {
                  DeckService().deleteDeckByName(widget.deckModel.name);
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Deck wurde gelöscht")));
                });
                onChange();
              }
              return delete;
            }
            if (direction == DismissDirection.endToStart) {
              return await showDialog<bool>(
                context: context,
                builder: (context) {
                  return const CustomAlertDialog(
                    title: "Bearbeiten",
                    message: "Sollen die enthaltenen Karten angepasst werden?",
                  );
                },
              );
            }
            return false;
          },
          onDismissed: (direction) async {
            if (direction == DismissDirection.endToStart) {
              Navigator.pushNamed(context, route.createDeckPage,
                      arguments: {"deckId": widget.deckModel.id})
                  .then((value) => onChange());
            }
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 56,
                  decoration: BoxDecoration(color: Colors.white.withOpacity(1)),
                  child: widget.deckModel.image != null
                      ? Image.file(
                          widget.deckModel.image!,
                          fit: BoxFit.cover,
                        )
                      : Container(),
                ),
                Container(
                  alignment: Alignment.center,
                  child: ExpansionTile(
                    initiallyExpanded: widget.initiallyExpanded,
                    trailing: const SizedBox(
                      width: 0,
                      height: 0,
                    ),
                    collapsedIconColor: Colors.white,
                    title: GestureDetector(
                      onLongPress: () => showDialog<String>(
                        context: context,
                        useRootNavigator: false,
                        builder: (BuildContext innerContext) => NameDeckDialog(
                          oldName: widget.deckModel.name,
                          onSaved: (deckName) => setState(
                            () {
                              DeckService()
                                  .renameDeck(widget.deckModel.id!, deckName)
                                  .then((value) => onChange());
                            },
                          ),
                        ),
                      ),
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
                            padding: const EdgeInsets.fromLTRB(0, 2, 0, 2),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.center,
                              child: Text(
                                widget.deckModel.name != ""
                                    ? widget.deckModel.name
                                    : "Temporäres Deck",
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
                          physics: const ClampingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: allCards.length + 1,
                          itemBuilder: (BuildContext context, int index) {
                            return index < allCards.length
                                ? CardInfoTile(
                                    onChanged: (bool? newValue) => (newValue),
                                    card: allCards[index],
                                    value: true,
                                    hasCheckbox: false,
                                    showCardCount: true,
                                  )
                                : DeckAdditionalInfoTile(
                                    deckModel: widget.deckModel,
                                    cards: allCards);
                          })
                    ],
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
                                        title: "Bild entfernen",
                                        message:
                                            "Soll das aktuelle Bild entfernt werden?",
                                        onConfirm: () => setState(() {
                                          widget.deckModel.image = null;
                                          deckService
                                              .updateDeck(widget.deckModel);
                                          deckService.removeCachedImage(
                                              widget.deckModel.name);
                                        }),
                                      );
                                    },
                                  );
                                },
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.camera,
                                    color: Colors.black,
                                  ),
                                  onPressed: () =>
                                      {pickImage().then((_) => onChange())},
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
    );
  }
}
