import 'dart:io';

import 'package:dominion_comanion/components/card_info_tile.dart';
import 'package:dominion_comanion/components/deck_additional_info_tile.dart';
import 'package:dominion_comanion/components/dropdown_rating.dart';
import 'package:dominion_comanion/model/deck/deck_model.dart';
import 'package:dominion_comanion/services/deck_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class DeckExpandable extends StatefulWidget {
  const DeckExpandable({
    super.key,
    required this.deckModel,
    this.initiallyExpanded = false,
    this.onLongPress,
  });

  final DeckModel deckModel;
  final bool initiallyExpanded;
  final void Function()? onLongPress;

  @override
  State<DeckExpandable> createState() => _DeckExpandableState();
}

class _DeckExpandableState extends State<DeckExpandable> {
  DeckService deckService = DeckService();

  File? image;

  // https://medium.com/unitechie/flutter-tutorial-image-picker-from-camera-gallery-c27af5490b74
  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() => this.image = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  // https://stackoverflow.com/questions/53908025/flutter-sortable-drag-and-drop-listview
  @override
  Widget build(BuildContext context) {
    final allCards = widget.deckModel.getAllCards();
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 56,
              decoration: BoxDecoration(color: Colors.white.withOpacity(1)),
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
                  onLongPress: () {
                    if (widget.onLongPress != null) {
                      widget.onLongPress!();
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(60, 0, 20, 0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image:
                                AssetImage("assets/menu/main_scroll_crop.png"),
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
                                deckModel: widget.deckModel, cards: allCards);
                      })
                ],
              ),
            ),
            Container(
              height: 56,
              padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
              child: Align(
                alignment: FractionalOffset.centerLeft,
                child: IconButton(
                  icon: const Icon(
                    Icons.camera,
                    color: Colors.black,
                  ),
                  onPressed: () => {
                    pickImage()
                  },
                ),
              ),
            ),
            Container(
              height: 56,
              padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
              child: Align(
                alignment: FractionalOffset.centerRight,
                child: DropdownSort(
                  rating: widget.deckModel.rating,
                  onChanged: (value) => {
                    widget.deckModel.rating =
                        value == null ? null : int.parse(value),
                    deckService.updateDeck(widget.deckModel)
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
