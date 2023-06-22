import 'package:dominion_comanion/components/deck_expandable.dart';
import 'package:dominion_comanion/model/deck/deck_model.dart';
import 'package:dominion_comanion/services/deck_service.dart';
import 'package:flutter/material.dart';

class LazyScrollViewDecks extends StatefulWidget {
  const LazyScrollViewDecks(
      {super.key, required this.onChange});

  final void Function() onChange;

  @override
  State<LazyScrollViewDecks> createState() => _LazyScrollViewDecksState();
}

class _LazyScrollViewDecksState extends State<LazyScrollViewDecks> {
  List<DeckModel> decks = [];
  bool showLoadingIcon = true;

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadExpansionRecursive();
    });
  }

  loadExpansionRecursive() async {
    DeckService().getDeckByPosition(decks.length).then(
          (element) => {
            setState(
              () {
                if (element != null) {
                  setState(() {
                    decks.add(element);
                  });
                  loadExpansionRecursive();
                } else {
                  setState(() {
                    showLoadingIcon = false;
                  });
                }
              },
            ),
          },
        );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 64),
        child: Column(
          children: [
            ...decks
                .map<Widget>((e) => DeckExpandable(
                      deckModel: e,
                      onDelete: () {
                        widget.onChange();
                      },
                      onRename: () {
                        widget.onChange();
                      },
                    ))
                .toList(),
            showLoadingIcon
                ? const Center(child: CircularProgressIndicator())
                : Container()
          ],
        ),
      ),
    );
  }
}
